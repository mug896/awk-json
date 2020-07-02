#!/usr/bin/env -S gawk -E

BEGIN {
    RS="^$"; FS=""
    INDENT = 2;
    keyword["true"]; keyword["false"]; keyword["null"]
    token[0] = opt1 = opt2 = ""
    idx = cdx = 0
}

BEGINFILE {
    if ( FILENAME ~ /^-k$|^-s$/ ) { opt1 = FILENAME; nextfile }
    if ( opt1 == "-s" && opt2 == "" ) { opt2 = FILENAME; nextfile }
}

{ tokenize() }

END { 
    if (opt1) search(); else pretty_print(0)
}


function search (path, sblock,       ckey, key, val) {
    for (    ; cdx < idx; cdx++) { 
        switch (token[cdx]) {
            case "{" :
            case "[" : 
                search( path "/" ckey, cdx++)
                break
            case "}" :
            case "]" : return
            case ":" : 
                ckey = gensub( /^"(.*)"$/, "\\1", "g", token[cdx - 1])
                key  = gensub( /\/{2,}/, "/", "g", path "/" ckey)
                if ( opt1 == "-k" ) print key 
                else if ( opt1 == "-s" ) {
                    if ( opt2 == key ) {
                        switch( token[cdx + 1] ) {
                            case "[" :
                            case "{" : pretty_print(cdx + 1); break
                            default  : print token[cdx + 1]
                        }
                    } else {
                        val = gensub( /^"(.*)"$/, "\\1", "g", token[cdx + 1])
                        if ( opt2 == key "=" val ) pretty_print(sblock)
                    }
                }
        }
    }
}

function tokenize (       i) {
    for (i=1; i <= NF; i++) {
        switch ($i) {
            case "{" : case "}" : 
            case "[" : case "]" : 
            case ":" : case "," : token[idx++] = $i; break
            case "\""           : i = t_string(i+1); break
            case /[0-9-]/       : i = t_number(i); break
            case /[a-z]/        : i = t_keyword(i); break
        }
    }
}

function t_keyword (i,     res) {
    while ( $i ~ /[a-z]/ ) res = res $(i++)
    if ( res in keyword ) token[idx++] = res
    return i - 1
}

function t_number (i,     res) {
    while ( $i ~ /[0-9.eE+-]/ ) res = res $(i++)
    token[idx++] = res
    return i - 1
}

function t_string (i,     res) {
    while (1) {
        if ( $i != "\"" ) res = res $(i++)
        else {
            if ( $(i-1) == "\\" ) res = res $(i++)
            else {
                token[idx++] = "\"" res "\""
                break
            }
        }
    }
    return i
}

function space (depth,   i, sp) { 
    depth = depth * INDENT
    for (i=0; i < depth; i++) sp = sp " "
    return sp
}

function pretty_print (start,    i, depth, prev, cur) {
    for (i = start; i < idx; i++) {
        prev = cur; cur = token[i]
        switch (cur) {
            case "{" : 
                printf (prev == ":" ? "" : "\n" space(depth)) "{"
                depth++; break
            case "}" : 
                depth--
                printf (prev == "{" ? " " : "\n" space(depth)) "}"
                break
            case "[" : 
                printf (prev == ":" ? "" : "\n" space(depth)) "["
                depth++; break
            case "]" : 
                depth--
                printf (prev == "[" ? " " : "\n" space(depth)) "]"
                break
            case "," : printf ","; break
            case ":" : printf ": "; break
            default : 
                printf (prev == ":" ? "" : "\n" space(depth)) cur
        }
        if (depth == 0) break
    }
    print ""
}
