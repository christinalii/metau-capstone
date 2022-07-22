
// The example below shows you how a cloud code function looks like.

// Parse Server 3.x
Parse.Cloud.define("validatePassword", (request) => {
  return("Hello world!");
});

Parse.Cloud.beforeSave(Parse.User, async (request) => {
  var username = await request.object.get("username");
  console.log("name = ", username);
  request.object.set(
    "searchName",
    username.toLowerCase()
  );
});

Parse.Cloud.beforeSave("VentAudience", async (request) => {
  var vent = await request.object.get("vent");
  var user = await request.object.get("user");
  var group = await request.object.get("group");

  request.object.set(
    "ventId",
    vent.id
  );

  if (user != null) {
    request.object.set(
      "userId",
      user.id
    );
  }
  if (group != null) {
    request.object.set(
      "groupId",
      group.id
    );
  }


});

Parse.Cloud.beforeSave("GroupMembership", async (request) => {
  var group = await request.object.get("group");
  var user = await request.object.get("user");

  request.object.set(
    "groupId",
    group.id
  );

  request.object.set(
    "userId",
    user.id
  );

});

Parse.Cloud.define("existsFollow", async (request) => {
 const query = new Parse.Query("Follow");
 query.equalTo("followingUserId", request.params.followingUserId);
 query.equalTo("currentUserId", request.params.currentUserId);
 const results = await query.find();
 if (results.length > 0) {
   return true;
 }
 return false;
});

Parse.Cloud.define("fetchUserCellData", async (request) => {
  console.log("Hello World");
  var limit = request.params.limit;
  var currentUserId = request.params.currentUserId;
  let results = [];
  var userQuery = new Parse.Query("User");
  if (request.params.searchString !== undefined) {
    userQuery.contains("searchName", request.params.searchString.toLowerCase());
  }
  userQuery.limit(limit);
  const userResult = await userQuery.find();
  for (let i = 0; i < userResult.length; i++) {
    var user = userResult[i];
    var followQuery = new Parse.Query("Follow");
    followQuery.equalTo("followingUserId", user.id);
    followQuery.equalTo("currentUserId", currentUserId);
    const followResult = await followQuery.find();
    if (followResult.length > 0) {
      var modelDict = {"isFollowing": true,
                    "user": user};
      results.push(modelDict);
    }
    else {
      var modelDict = {"isFollowing": false,
                    "user": user};
      results.push(modelDict);
    }

  }
  return results;
});

Parse.Cloud.define("fetchPotentialAudienceUsers", async (request) => {
  var limit = request.params.limit;
  let results = [];
  var followQuery = new Parse.Query("Follow");
  followQuery.equalTo("followingUserId", request.params.currentUserId);
  followQuery.equalTo("approved", true);
  followQuery.limit(limit);
  followQuery.include("currentUser");
  const followResult = await followQuery.find();
  return followResult;
});

Parse.Cloud.define("fetchPotentialAudienceGroups", async (request) => {
  var limit = request.params.limit;
  let results = [];
  var groupQuery = new Parse.Query("GroupDetails");
  groupQuery.equalTo("groupAuthorUserId", request.params.groupAuthorUserId);
  groupQuery.limit(limit);
  groupQuery.include("currentUser");
  const groupResult = await groupQuery.find();
  return groupResult;
});

Parse.Cloud.define("fetchHomeTimeline", async (request) => {
  var limit = request.params.limit;
  var currentUserId = request.params.currentUserId;
  let results = [];

  //get users that currentUser is following
  var followQuery = new Parse.Query("Follow");
  followQuery.equalTo("currentUserId", currentUserId);
  followQuery.equalTo("approved", true);
  followQuery.include("followingUserId");
  const followResult = await followQuery.find();
  var followingUsersIds = followResult.map(a => a.get("followingUserId"));

  // get following's vents
  var ventsQuery = new Parse.Query("Vent");
  ventsQuery.containedIn("authorUserId", followingUsersIds);
  const rawVents = await ventsQuery.find();
  var rawVentsIds = rawVents.map(a => a.id);

  // get following's groups that currentUser is in
  var groupsQuery = new Parse.Query("GroupDetails");
  groupsQuery.containedIn("groupAuthorUserId", followingUsersIds);
  groupsQuery.include("objectId");
  const groups = await groupsQuery.find();
  var groupsArray = groups.map(a => a.id);
  groupsArray.push(undefined);

  let currentUserArray = [currentUserId];
  currentUserArray.push(undefined);

  // get vents
  var vaQuery = new Parse.Query("VentAudience");
  vaQuery.containedIn("ventId", rawVentsIds);
  vaQuery.containedIn("userId", currentUserArray);
  vaQuery.containedIn("groupId", groupsArray);
  vaQuery.include("vent");
  vaQuery.limit(limit);
  vaQuery.descending("createdAt");
  var vaResults = await vaQuery.find();
  var ventsArray = vaResults.map(a => a.get("vent"));

  // remove duplicate vents
  var filteredVentsArray = ventsArray.filter((v,i,a)=>a.findIndex(v2=>(v2.id===v.id))===i);

  return filteredVentsArray;
});

/* Parse Server 2.x
* Parse.Cloud.define("hello", function(request, response){
* 	response.success("Hello world!");
* });
*/

// To see it working, you only need to call it through SDK or REST API.
// Here is how you have to call it via REST API:

/** curl -X POST \
* -H "X-Parse-Application-Id: kniju7zULq2flcCwJ7PEG3U8bgQlxqFMBn2NEKPH" \
* -H "X-Parse-REST-API-Key: SgJDPTnyrRLmSUWkM7bIQ3BLwgdPDTH6qidYBBmN" \
* -H "Content-Type: application/json" \
* -d "{}" \
* https://parseapi.back4app.com/functions/hello
*/

// If you have set a function in another cloud code file, called "test.js" (for example)
// you need to refer it in your main.js, as you can see below:

/* require("./test.js"); */
