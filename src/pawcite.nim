import puppy, json, strformat, strutils, parseopt

proc fetchJson*(url: string): JsonNode =
    let resp = get(url)
    let raw = parseJson(resp.body)
    return raw

proc format_crossref_citation*(doi: string): string =
    let data    = fetchJson("https://api.crossref.org/works/" & doi)
    let authors = data["message"]["author"]
    var firstAuthor: JsonNode

    for author in authors:
        if author["sequence"].getStr == "first":
            firstAuthor = author
            break

    let etal = if authors.len > 1: " et al." else: ""
    let yearStr = $data["message"]["published-online"]["date-parts"][0][0].getInt
    result = firstAuthor["family"].getStr &
                " " & toUpperAscii(firstAuthor["given"].getStr[0]) & "." &
                etal & ", " &
                data["message"]["short-container-title"][0].getStr & ". (" &
                yearStr & ")"

when isMainModule:
    var p = initOptParser()
    while true:
        p.next()
        case p.kind
        of cmdEnd: break
        of cmdArgument:
            echo format_crossref_citation(p.key)
        else: discard
