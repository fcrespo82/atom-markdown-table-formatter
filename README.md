# Markdown Table Formatter

A simple markdown plugin to format tables.

Based on the awesome [Improved Markdown table commands for TextMate](http://www.leancrew.com/all-this/2012/03/improved-markdown-table-commands-for-textmate/) work from [Dr. Drang (@drdrang)](https://twitter.com/drdrang)

[Changelog](https://github.com/fcrespo82/atom-markdown-table-formatter/blob/master/CHANGELOG.md)


## Usage

There are two basic ways of using this plugin.

1. Select the table you want to format and them hit `alt-shift-T` to format it.
2. If you didn't select any table the entire document (default) will be scanned, by the plugin, for tables and format all of them.

### Settings & Keybindings

![Settings image](https://github.com/fcrespo82/atom-markdown-table-formatter/raw/master/settings.png)

## Tips

### How to style the tables correctly if you use non-monospace fonts

```css
atom-text-editor::shadow .table.gfm {
    font-family: monospace;
}
```
