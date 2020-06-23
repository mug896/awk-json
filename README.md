# awk script for json search

## 1. Pretty printing

sample data

```bash
$ cat sample.json
{"squadName":"Super hero squad","homeTown":"Metro City","formed":2016,"secretBase":
"Super tower","active":true,"members":[{"name":"Molecule Man","age":29,"secretIdentity":
"Dan Jukes","powers":["Radiation resistance","Turning tiny","Radiation blast"]},{"name":
"Madame Uppercut","age":39,"secretIdentity":"Jane Wilson","powers":["Million tonne punch",
"Damage resistance","Superhuman reflexes"]},{"name":"Eternal Flame","age":1000000,
"secretIdentity":"Unknown","powers":["Immortality","Heat Immunity","Teleportation",
"Interdimensional travel"]}]}
```

```bash
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

|     Option     |     Detail     |
| -------------- | -------------- |
| `-k`           | Print all keys |
| `-s key`       | Print key's values |
| `-s key=value` | Print blocks of key=value |


```bash
$ ./json.sh -k sample.json
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

$ ./json.sh -s /members/name sample.json
"Molecule Man"
"Madame Uppercut"
"Eternal Flame"

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
