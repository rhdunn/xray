xquery version "1.0-ml";

import module namespace xray = "http://github.com/robwhitby/xray" at "src/xray.xqy";

(: where to look for tests :)
declare variable $dir as xs:string := xdmp:get-request-field("dir", "test");

(: module name matcher regex :)
declare variable $modules as xs:string? := xdmp:get-request-field("modules");

(: test name matcher regex :)
declare variable $tests as xs:string? := xdmp:get-request-field("tests");

(: output format xml|html|text|xunit :)
declare variable $format as xs:string := xdmp:get-request-field("format", "html");

(: library module paths for code coverage :)
declare variable $coverage-modules as xs:string* := fn:distinct-values(
  if ($format = "xunit") then () else xdmp:get-request-field("coverage-module")[. ne ""]
);

(: Set the content-type here,
 : so we can test xray:transform with any format.
 :)
if ($format eq "text") then xdmp:set-response-content-type("text/plain")
else (),

xray:run-tests($dir, $modules, $tests, $format, $coverage-modules)
