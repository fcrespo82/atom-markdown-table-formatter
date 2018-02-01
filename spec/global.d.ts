interface ObjectConstructor {
  keys<K extends string>(o: { [Key in K]: any }): K[]
  entries<K extends string, T>(o: { [Key in K]: T }): [K, T][]
}
