import puppy, json, strformat, strutils, parseopt

proc fetchJson*(url: string): JsonNode =
    let resp = get(url)
    if resp.code != 200:
        raise newException(ValueError, &"HTTP error: {resp.code}")
    return parseJson(resp.body)

proc format_crossref_citation*(doi: string): string =
    let msg = fetchJson("https://api.crossref.org/works/" & doi)["message"]
    let authors =
        if msg.hasKey("author"):
            msg["author"].getElems
        else:
            @[]
    var firstAuthor: JsonNode

    for author in authors:
        if author["sequence"].getStr == "first":
            firstAuthor = author
            break

    if firstAuthor.len == 0:
        if authors.len > 0:
            firstAuthor = authors[0]
        else:
            raise newException(ValueError, "No author in DOI data")
    let yearParts =
        if msg.hasKey("published-online"):
            msg["published-online"]["date-parts"][0]
        elif msg.hasKey("published-print"):
            msg["published-print"]["date-parts"][0]
        else:
            raise newException(ValueError, "No published date in dOI data")
    
    let year = $yearParts[0]
    let family = firstAuthor["family"].getStr
    let given = firstAuthor["given"].getStr
    let initial =
        if given.len > 0:
            $(toUpperAscii(given[0])) & "."
        else:
            ""
    let etal    = if authors.len > 1: " et al." else: ""

    let containerTitle = 
        if msg.hasKey("short-container-title"):
            msg["short-container-title"][0]
        elif msg.hasKey("container-title"):
            msg["container-title"][0]
        else:
            raise newException(ValueError, "No container data in dOI data")

    result = fmt"{family} {initial}{etal}, {containerTitle}. ({year})"

when isMainModule:
    if paramCount() == 0:
        echo "Usage: nimrun citation.nim <DOI> [<DOI> ...]"
        quit(1)
    for i in 1..paramCount():
        try:
            echo formatCrossrefCitation(paramStr(i))
        except ValueError as e:
            echo "Error for DOI ", paramStr(i), ": ", e.msg
