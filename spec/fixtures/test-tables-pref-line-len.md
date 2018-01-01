
# Input
| aaa | aaa | aaa | aaa | aaa | aaaaaaa |
| --- | --- | --- | --- | --- | --------------------------------------------------------- |
| bbb | bbb | bbb | bbb | bbb | bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb |

# Expected
| aaa | aaa | aaa | aaa | aaa | aaaaaaa                                        |
|:----|:----|:----|:----|:----|:-----------------------------------------------|
| bbb | bbb | bbb | bbb | bbb | bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb |

# Input
|Coffee||
|:---|:---|
|Origin/Name|[prompt:Origin/Name]|
|Brew method|[list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other]|
|Brewer|[prompt:Who brewed it?]|
|Rating|[list:Rating|★☆☆|★★☆|★★★]|
|Notes|[prompt:Notes]|

# Expected
| Coffee      |                                                                |
|:------------|:---------------------------------------------------------------|
| Origin/Name | [prompt:Origin/Name]                                           |
| Brew method | [list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other] |
| Brewer      | [prompt:Who brewed it?]                                        |
| Rating      | [list:Rating|★☆☆|★★☆|★★★]                                      |
| Notes       | [prompt:Notes]                                                 |
