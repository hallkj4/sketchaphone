import AWSAppSync

let CognitoIdentityPoolId = "us-west-2_AOGYjBEBz"
let S3BUCKET = "skechaphone-drawings"
let AWSRegion = AWSRegionType.USWest2
let AWSRegionString = "us-west-2"
let AppSyncEndpointURL: URL = URL(string: "https://jwz4x4uzbvakjbc53kwu753t4u.appsync-api.us-west-2.amazonaws.com/graphql")!
let database_name = "appsync-local-db"

var appSyncClient: AWSAppSyncClient?
