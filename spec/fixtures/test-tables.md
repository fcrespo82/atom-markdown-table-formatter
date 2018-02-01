
# Input
|Left|Center|Right|
|:-|:-:|-:|
|1|2|3|

# Expected
| Left | Center | Right |
|:-----|:------:|------:|
| 1    |   2    |     3 |

# Input
| h1 h1| h2 | h3 |
|-|-|-|
| data1 | data2 | data3 |

# Expected
| h1 h1 | h2    | h3    |
|:------|:------|:------|
| data1 | data2 | data3 |

# Input
h1 | h2 | h3
-|-|-
data-1 | data-2 | data-3

# Expected
| h1     | h2     | h3     |
|:-------|:-------|:-------|
| data-1 | data-2 | data-3 |

# Input
-|-|-
a|b|c

# Expected
|:--|:--|:--|
| a | b | c |

# Input
| Header 1 | Header 2 | Header 3 |
|----|---|-|
| data1a | Data is longer than header | 1 |
| d1b | add a cell|
|lorem|ipsum|3|
| | empty outside cells
| skip| | 5 |
| six | Morbi purus | 6 |

# Expected
| Header 1 | Header 2                   | Header 3 |
|:---------|:---------------------------|:---------|
| data1a   | Data is longer than header | 1        |
| d1b      | add a cell                 |          |
| lorem    | ipsum                      | 3        |
|          | empty outside cells        |          |
| skip     |                            | 5        |
| six      | Morbi purus                | 6        |

# Input
|teste-3|
|---|
|other|

# Expected
| teste-3 |
|:--------|
| other   |

# Input
|outro
|-
|teste

# Expected
| outro |
|:------|
| teste |

# Input
outro|
:-:|
teste|

# Expected
| outro |
|:-----:|
| teste |

# Input
First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell

# Expected
| First Header | Second Header |
|:-------------|:--------------|
| Content Cell | Content Cell  |
| Content Cell | Content Cell  |

# Input
| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |

# Expected
| First Header | Second Header |
|:-------------|:--------------|
| Content Cell | Content Cell  |
| Content Cell | Content Cell  |

# Input
| Item      | Value |
| --------- | -----:|
| Computer  | $1600 |
| Phone     |   $12 |
| Pipe      |    $1 |

# Expected
| Item     | Value |
|:---------|------:|
| Computer | $1600 |
| Phone    |   $12 |
| Pipe     |    $1 |

# Input
| Function name | Description                    |
| ------------- | ------------------------------ |
| `help()`      | Display the help window.       |
| `destroy()`   | **Destroy your computer!**     |

# Expected
| Function name | Description                |
|:--------------|:---------------------------|
| `help()`      | Display the help window.   |
| `destroy()`   | **Destroy your computer!** |

# Input
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |

# Expected
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |

# Input
|Left align|Right align|Center align|
|:---------|----------:|:----------:|
|This|This|This|
|column|column|column|
|will|will|will|
|be|be|be|
|left|right|center|
|aligned|aligned|aligned|

# Expected
| Left align | Right align | Center align |
|:-----------|------------:|:------------:|
| This       |        This |     This     |
| column     |      column |    column    |
| will       |        will |     will     |
| be         |          be |      be      |
| left       |       right |    center    |
| aligned    |     aligned |   aligned    |

# Input
| Name | Description          |
| ------------- | ----------- |
| Help      | Display the help window.|
| Close     | Closes a window     |

# Expected
| Name  | Description              |
|:------|:-------------------------|
| Help  | Display the help window. |
| Close | Closes a window          |

# Input
| Name | Description          |
| ------------- | ----------- |
| Help      | ~~Display the~~ help window.|
| Close     | _Closes_ a window     |

# Expected
| Name  | Description                  |
|:------|:-----------------------------|
| Help  | ~~Display the~~ help window. |
| Close | _Closes_ a window            |

# Input
| Left-Aligned  | Center Aligned  | Right Aligned |
| :------------ |:---------------:| -----:|
| col 3 is      | some wordy text | $1600 |
| col 2 is      | centered        |   $12 |
| zebra stripes | are neat        |    $1 |

# Expected
| Left-Aligned  | Center Aligned  | Right Aligned |
|:--------------|:---------------:|--------------:|
| col 3 is      | some wordy text |         $1600 |
| col 2 is      |    centered     |           $12 |
| zebra stripes |    are neat     |            $1 |

# Input
| First Header | Second Header |         Third Header |
| :----------- | :-----------: | -------------------: |
| First row    |      Data     | Very long data entry |
| Second row   |    **Cell**   |               *Cell* |

# Expected
| First Header | Second Header |         Third Header |
|:-------------|:-------------:|---------------------:|
| First row    |     Data      | Very long data entry |
| Second row   |   **Cell**    |               *Cell* |

# Input
|Coffee||
|:---|:---|
|Origin/Name|[prompt:Origin/Name]|
|Brew method|[list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other]|
|Brewer|[prompt:Who brewed it?]|
|Rating|[list:Rating|★☆☆|★★☆|★★★]|
|Notes|[prompt:Notes]|

# Expected
| Coffee      |                                                                                |
|:------------|:-------------------------------------------------------------------------------|
| Origin/Name | [prompt:Origin/Name]                                                           |
| Brew method | [list:Brew Method|AeroPress|Chemex|Drip|Espresso|French Press|Pour Over|Other] |
| Brewer      | [prompt:Who brewed it?]                                                        |
| Rating      | [list:Rating|★☆☆|★★☆|★★★]                                                      |
| Notes       | [prompt:Notes]                                                                 |

# Input
code|描述|详细解释
:-|:-|:-
200|成功|成功
400|错误请求|该请求是无效的，详细的错误信息会说明原因
401|验证错误|验证失败，详细的错误信息会说明原因
403|被拒绝|被拒绝调用，详细的错误信息会说明原因
404|无法找到|资源不存在
429|过多的请求|超出了调用频率限制，详细的错误信息会说明原因
500|内部服务错误|服务器内部出错了，请联系我们尽快解决问题
504|内部服务响应超时|服务器在运行，本次请求响应超时,请稍后重试

# Expected
| code | 描述             | 详细解释                                     |
|:-----|:-----------------|:---------------------------------------------|
| 200  | 成功             | 成功                                         |
| 400  | 错误请求         | 该请求是无效的，详细的错误信息会说明原因     |
| 401  | 验证错误         | 验证失败，详细的错误信息会说明原因           |
| 403  | 被拒绝           | 被拒绝调用，详细的错误信息会说明原因         |
| 404  | 无法找到         | 资源不存在                                   |
| 429  | 过多的请求       | 超出了调用频率限制，详细的错误信息会说明原因 |
| 500  | 内部服务错误     | 服务器内部出错了，请联系我们尽快解决问题     |
| 504  | 内部服务响应超时 | 服务器在运行，本次请求响应超时,请稍后重试    |

# Input
заголовок|таблицы
-|-
тело|таблицы
продолжение|тела

# Expected
| заголовок   | таблицы |
|:------------|:--------|
| тело        | таблицы |
| продолжение | тела    |

# Input (regression test for #16)
| test | table | with| many | columns |
|-|-|-|-|-
|asd
|dsa

# Expected
| test | table | with | many | columns |
|:-----|:------|:-----|:-----|:--------|
| asd  |       |      |      |         |
| dsa  |       |      |      |         |

# Input (regression test for #17)
| **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
|:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
| Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
| CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
| SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |

# Expected
| **Name**        | **Unicode**                           | **Unicode Name**                                      | **ASCII Dec**  |
|:----------------|:--------------------------------------|:------------------------------------------------------|:---------------|
| Digits          | The code points U+0030 through U+0039 | DIGIT ZERO through DIGIT NINE                         | 48 through 57  |
| CA­PI­TAL-LETTERS | The code points U+0041 through U+005A | LATIN CA­PI­TAL LET­TER A through LATIN CA­PI­TAL LET­TER Z | 65 through 90  |
| SMALL-LETTERS   | The code points U+0061 through U+007A | LATIN SMALL LET­TER A through LATIN SMALL LET­TER Z     | 97 through 122 |

# Input (regression test for #24)
|
|-|-|-|-|
|table | with |empty |header|

# Expected
|       |      |       |        |
|:------|:-----|:------|:-------|
| table | with | empty | header |
