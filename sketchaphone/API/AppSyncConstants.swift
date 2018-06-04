import AWSAppSync

let CognitoAWSRegion = AWSRegionType.USEast1
let CognitoPoolId = "us-east-1_b2dwuMxth"
let CognitoIdentityPoolId = "us-east-1:09824db8-6c1e-4adc-8347-d071458c7f99"
let CognitoAppId = "f1tmlg79com5qg19m4260gfg2"
let CognitoAppClientSecret = "d87ie09ig6rocufao36uvthvr04u7hcd604hojsqq6kr1b4gj40"

let S3BUCKET = "skechaphone-drawings"
let AWSRegion = AWSRegionType.USWest2
let AWSRegionString = "us-west-2"

let AppSyncEndpointURL: URL = URL(string: "https://jwz4x4uzbvakjbc53kwu753t4u.appsync-api.us-west-2.amazonaws.com/graphql")!
let database_name = "appsync-local-db"

var appSyncClient: AWSAppSyncClient?
