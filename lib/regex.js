"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const XRegExp = require("xregexp");
exports.regex = XRegExp(`\
( # header capture
  (?:
    (?:[^\\r\\n]*?\\|[^\\r\\n]*)       # line w/ at least one pipe
    \\ *                       # maybe trailing whitespace
  )?                          # maybe header
  (?:\\r?\\n|^)                 # newline
)
( # format capture
  (?:
    \\|\\ *(?::?-+:?|::)\\ *            # format starting w/pipe
    |\\|?(?:\\ *(?::?-+:?|::)\\ *\\|)+   # or separated by pipe
  )
  (?:\\ *(?::?-+:?|::)\\ *)?           # maybe w/o trailing pipe
  \\ *                         # maybe trailing whitespace
  \\r?\\n                       # newline
)
( # body capture
  (?:
    (?:[^\\r\\n]*?\\|[^\\r\\n]*)       # line w/ at least one pipe
    \\ *                       # maybe trailing whitespace
    (?:\\r?\\n|$)               # newline
  )+ # at least one
)
`, 'gx');
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoicmVnZXguanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvcmVnZXgudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUFBQSxtQ0FBbUM7QUFFdEIsUUFBQSxLQUFLLEdBQUcsT0FBTyxDQUMxQjs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0NBd0JELEVBQ0MsSUFBSSxDQUNMLENBQUEiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgWFJlZ0V4cCA9IHJlcXVpcmUoJ3hyZWdleHAnKVxuXG5leHBvcnQgY29uc3QgcmVnZXggPSBYUmVnRXhwKFxuICBgXFxcbiggIyBoZWFkZXIgY2FwdHVyZVxuICAoPzpcbiAgICAoPzpbXlxcXFxyXFxcXG5dKj9cXFxcfFteXFxcXHJcXFxcbl0qKSAgICAgICAjIGxpbmUgdy8gYXQgbGVhc3Qgb25lIHBpcGVcbiAgICBcXFxcICogICAgICAgICAgICAgICAgICAgICAgICMgbWF5YmUgdHJhaWxpbmcgd2hpdGVzcGFjZVxuICApPyAgICAgICAgICAgICAgICAgICAgICAgICAgIyBtYXliZSBoZWFkZXJcbiAgKD86XFxcXHI/XFxcXG58XikgICAgICAgICAgICAgICAgICMgbmV3bGluZVxuKVxuKCAjIGZvcm1hdCBjYXB0dXJlXG4gICg/OlxuICAgIFxcXFx8XFxcXCAqKD86Oj8tKzo/fDo6KVxcXFwgKiAgICAgICAgICAgICMgZm9ybWF0IHN0YXJ0aW5nIHcvcGlwZVxuICAgIHxcXFxcfD8oPzpcXFxcICooPzo6Py0rOj98OjopXFxcXCAqXFxcXHwpKyAgICMgb3Igc2VwYXJhdGVkIGJ5IHBpcGVcbiAgKVxuICAoPzpcXFxcICooPzo6Py0rOj98OjopXFxcXCAqKT8gICAgICAgICAgICMgbWF5YmUgdy9vIHRyYWlsaW5nIHBpcGVcbiAgXFxcXCAqICAgICAgICAgICAgICAgICAgICAgICAgICMgbWF5YmUgdHJhaWxpbmcgd2hpdGVzcGFjZVxuICBcXFxccj9cXFxcbiAgICAgICAgICAgICAgICAgICAgICAgIyBuZXdsaW5lXG4pXG4oICMgYm9keSBjYXB0dXJlXG4gICg/OlxuICAgICg/OlteXFxcXHJcXFxcbl0qP1xcXFx8W15cXFxcclxcXFxuXSopICAgICAgICMgbGluZSB3LyBhdCBsZWFzdCBvbmUgcGlwZVxuICAgIFxcXFwgKiAgICAgICAgICAgICAgICAgICAgICAgIyBtYXliZSB0cmFpbGluZyB3aGl0ZXNwYWNlXG4gICAgKD86XFxcXHI/XFxcXG58JCkgICAgICAgICAgICAgICAjIG5ld2xpbmVcbiAgKSsgIyBhdCBsZWFzdCBvbmVcbilcbmAsXG4gICdneCcsXG4pXG4iXX0=