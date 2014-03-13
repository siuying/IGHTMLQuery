Changelog
=========
0.8.1 (13/3/2014)
-----------------

* Added: ``[node innerHtml]`` and ``[node html]``. Like ``[node innerXml]`` and ``[node xml]``, they return the markup of the node. If you are working on HTML document, you should use the html version of the method, as they handle self-closing tag differently.  

0.8.0 (7/3/2014)
-----------------
* Added: [node query:] and [nodeSet query:] which automatically select query using XPath or CSS Selector.
* Fixes bug for IGXMLNode equality.
* [nodeSet enumerateNodesUsingBlock:] now enumerate the order of the set instead of reversed.

0.7.2 (25/2/2014)
-----------------
* Remove the HTML_PARSE_NOIMPLIED option in HTML parser.

0.7.1 (28/1/2014)
-----------------
* Use CSSSelectorConverter 1.1.0, fixes critical selector match issue.

0.7.0 (23/1/2014)
-----------------
+ Introduce [node queryWithCSS:], query node using CSS Selector Level 3 (powered by [CSSSelectorConverter](https://github.com/siuying/CSSSelectorConverter))
- [Ruby] Fixes a bug wrapping return values.

0.6.6 (5/1/2014)
----------------
- [JavaScript] Fixed a bug using IGHTMLDocument

0.6.5 (4/1/2014)
----------------
+ [JavaScript] add HTMLDoc, allow creation of document with HTML on JavaScript side.
+ Add IGHTMLQuery::HTTP.get method, that a simple wrapper to perform a HTTP request.