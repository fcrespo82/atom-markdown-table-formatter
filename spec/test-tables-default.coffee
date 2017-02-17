module.exports =
  Left:
    [
        test: '''
          |First Header|Second Header|Third Header|
          |-|-:|:-:|
          |Content|Content|Content|
          |Content|Content|Content|

          '''
        expected: '''
          | First Header | Second Header | Third Header |
          |:-------------|--------------:|:------------:|
          | Content      |       Content |   Content    |
          | Content      |       Content |   Content    |

          '''
    ]
  Center:
    [
        test: '''
          |First Header|Second Header|Third Header|
          |-|:-|::|
          |Content|Content|Content|
          |Content|Content|Content|

          '''
        expected: '''
          | First Header | Second Header | Third Header |
          |:------------:|:--------------|:------------:|
          |   Content    | Content       |   Content    |
          |   Content    | Content       |   Content    |

          '''
    ]
  Right:
    [
        test: '''
          |First Header|Second Header|
          |-|:-|
          |Content|Content|
          |Content|Content|

          '''
        expected: '''
          | First Header | Second Header |
          |-------------:|:--------------|
          |      Content | Content       |
          |      Content | Content       |

          '''
    ]
