import AWSAppSync

let CognitoAWSRegion = AWSRegionType.USWest2
let CognitoPoolId = "us-west-2_AOGYjBEBz"
let CognitoIdentityPoolId = "us-west-2:949ac5f7-a5ed-4a1f-975c-bfff3f9a571b"
let CognitoAppId = "3opl5him2odnff9dq531rk806q"

let S3BUCKET = "skechaphone-drawings"
let AWSRegion = AWSRegionType.USWest2
let AWSRegionString = "us-west-2"

let AppSyncEndpointURL: URL = URL(string: "https://jwz4x4uzbvakjbc53kwu753t4u.appsync-api.us-west-2.amazonaws.com/graphql")!
let API_HOST = "jwz4x4uzbvakjbc53kwu753t4u.appsync-api.us-west-2.amazonaws.com"
let database_name = "appsync-local-db"

var appSyncClient: AWSAppSyncClient?
