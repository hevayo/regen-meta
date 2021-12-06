import ballerina/http;
import ballerina/io;

type ConnectorsResponse record {
    Connector[] connectors;
};

type Connector record {
    string name;
    string moduleName;
    int id;
    Package package;
};

type Package record {
    string summary;
    string balaURL;
    string organization;
    string name;
    string digest;
    string balaVersion;
    string readme;
    string 'version;
    string languageSpecificationVersion;
    string platform;
    string URL;
};

http:Client central = check new ("https://api.central.ballerina.io/2.0/");

public function main() returns error? {
    int offset = 10;
    int limitq = 10;
    foreach var i in 2 ... 50 {
        int off = (offset * i);
        ConnectorsResponse response = check central->get("/registry/connectors?" + "offset=" + off.toBalString() + "&limit=10");
        foreach Connector c in response.connectors {
            http:Response|error r = central->get("/docs/" + c.package.organization + "/" + c.package.name + "/" + c.package.'version + "?regenerate=true");
            io:println("Regenerating " + c.package.organization + "/" + c.package.name);
        }
    }

}
