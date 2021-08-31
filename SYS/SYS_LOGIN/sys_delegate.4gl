IMPORT COM
IMPORT FGL WSHelper
PRIVATE CONSTANT C_GENERO_INTERNAL_DELEGATE = "_GENERO_INTERNAL_DELEGATE_"
MAIN
    DEFINE req com.HTTPServiceRequest

    CALL com.WebServiceEngine.Start()
    LET req = com.WebServiceEngine.GetHttpServiceRequest(-1)

    CALL req.setResponseHeader(
        "URL", req.getURL() || "&Arg=" || req.getURLHost())

    CALL req.setResponseHeader("X-FourJs-Environment-CLIENT_IP", req.getURLHost())
    CALL req.sendResponse(307, C_GENERO_INTERNAL_DELEGATE)
END MAIN
