# awk script for jsone search

## 1. Pretty printing

```bash
$ cat sample.json
{"squadName":"Super hero squad","homeTown":"Metro City","formed":2016,"secretBase":
"Super tower","active":true,"members":[{"name":"Molecule Man","age":29,"secretIdentity":
"Dan Jukes","powers":["Radiation resistance","Turning tiny","Radiation blast"]},{"name":
"Madame Uppercut","age":39,"secretIdentity":"Jane Wilson","powers":["Million tonne punch",
"Damage resistance","Superhuman reflexes"]},{"name":"Eternal Flame","age":1000000,
"secretIdentity":"Unknown","powers":["Immortality","Heat Immunity","Teleportation",
"Interdimensional travel"]}]}

$ ./json.sh sample.json

{
  "squadName": "Super hero squad",
  "homeTown": "Metro City",
  "formed": 2016,
  "secretBase": "Super tower",
  "active": true,
  "members": [
    {
      "name": "Molecule Man",
      "age": 29,
      "secretIdentity": "Dan Jukes",
      "powers": [
        "Radiation resistance",
        "Turning tiny",
        "Radiation blast"
      ]
    },
    {
      "name": "Madame Uppercut",
      "age": 39,
      "secretIdentity": "Jane Wilson",
      "powers": [
        "Million tonne punch",
        "Damage resistance",
        "Superhuman reflexes"
      ]
    },
    {
      "name": "Eternal Flame",
      "age": 1000000,
      "secretIdentity": "Unknown",
      "powers": [
        "Immortality",
        "Heat Immunity",
        "Teleportation",
        "Interdimensional travel"
      ]
    }
  ]
}
```


## 2. Searching

```bash
$ ./json.sh -k sample.json       # 전체 key 값을 출력
/squadName
/homeTown
/formed
/secretBase
/active
/members
/members/name
/members/age
/members/secretIdentity
/members/powers
/members/name
/members/age
/members/secretIdentity
/members/powers
/members/name
/members/age
/members/secretIdentity
/members/powers

# key 값이 /members/name 인 value 를 모두 출력
$ ./json.sh -s /members/name sample.json
"Molecule Man"
"Madame Uppercut"
"Eternal Flame"

# /members/name 의 value 가 "Molecule Man" 인 전체 블록을 출력
$ ./json.sh -s /members/name="Molecule Man" sample.json 

{
  "name": "Molecule Man",
  "age": 29,
  "secretIdentity": "Dan Jukes",
  "powers": [
    "Radiation resistance",
    "Turning tiny",
    "Radiation blast"
  ]
}
```
