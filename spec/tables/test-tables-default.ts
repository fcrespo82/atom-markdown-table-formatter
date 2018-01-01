export = {
  Left: [
    {
      input: `\
|First Header|Second Header|Third Header|
|-|-:|:-:|
|Content|Content|Content|
|Content|Content|Content|
\
`,
      expected: `\
| First Header | Second Header | Third Header |
|:-------------|--------------:|:------------:|
| Content      |       Content |   Content    |
| Content      |       Content |   Content    |
\
`,
    },
  ],
  Center: [
    {
      input: `\
|First Header|Second Header|Third Header|
|-|:-|::|
|Content|Content|Content|
|Content|Content|Content|
\
`,
      expected: `\
| First Header | Second Header | Third Header |
|:------------:|:--------------|:------------:|
|   Content    | Content       |   Content    |
|   Content    | Content       |   Content    |
\
`,
    },
  ],
  Right: [
    {
      input: `\
|First Header|Second Header|
|-|:-|
|Content|Content|
|Content|Content|
\
`,
      expected: `\
| First Header | Second Header |
|-------------:|:--------------|
|      Content | Content       |
|      Content | Content       |
\
`,
    },
  ],
}
