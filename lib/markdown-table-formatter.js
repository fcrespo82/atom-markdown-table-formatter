"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const table_formatter_1 = require("./table-formatter");
var config_1 = require("./config");
exports.config = config_1.config;
let tableFormatter;
let command;
function activate() {
    tableFormatter = new table_formatter_1.TableFormatter();
    command = atom.commands.add('atom-text-editor', {
        'markdown-table-formatter:format': event => {
            const editor = event.currentTarget.getModel();
            tableFormatter.format(editor);
        },
        'markdown-table-formatter:enable-for-current-scope'(event) {
            const editor = event.currentTarget.getModel();
            const scope = editor.getGrammar().scopeName;
            const key = 'markdown-table-formatter.markdownGrammarScopes';
            const current = atom.config.get(key);
            if (!scope) {
                atom.notifications.addError('Could not determine editor grammar scope');
            }
            else if (current.includes(scope)) {
                atom.notifications.addWarning(`${scope} already considered Markdown`);
            }
            else {
                atom.config.set(key, [...current, scope]);
                atom.notifications.addSuccess(`Successfully added ${scope} to Markdown scopes`);
            }
        },
    });
}
exports.activate = activate;
function deactivate() {
    command.dispose();
    tableFormatter.destroy();
}
exports.deactivate = deactivate;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWFya2Rvd24tdGFibGUtZm9ybWF0dGVyLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vc3JjL21hcmtkb3duLXRhYmxlLWZvcm1hdHRlci50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQUFBLHVEQUFrRDtBQUVsRCxtQ0FBaUM7QUFBeEIsMEJBQUEsTUFBTSxDQUFBO0FBRWYsSUFBSSxjQUE4QixDQUFBO0FBQ2xDLElBQUksT0FBbUIsQ0FBQTtBQUV2QjtJQUNFLGNBQWMsR0FBRyxJQUFJLGdDQUFjLEVBQUUsQ0FBQTtJQUVyQyxPQUFPLEdBQUcsSUFBSSxDQUFDLFFBQVEsQ0FBQyxHQUFHLENBQUMsa0JBQWtCLEVBQUU7UUFDOUMsaUNBQWlDLEVBQUUsS0FBSyxDQUFDLEVBQUU7WUFDekMsTUFBTSxNQUFNLEdBQUcsS0FBSyxDQUFDLGFBQWEsQ0FBQyxRQUFRLEVBQUUsQ0FBQTtZQUM3QyxjQUFjLENBQUMsTUFBTSxDQUFDLE1BQU0sQ0FBQyxDQUFBO1FBQy9CLENBQUM7UUFDRCxtREFBbUQsQ0FBQyxLQUFLO1lBQ3ZELE1BQU0sTUFBTSxHQUFHLEtBQUssQ0FBQyxhQUFhLENBQUMsUUFBUSxFQUFFLENBQUE7WUFDN0MsTUFBTSxLQUFLLEdBQUcsTUFBTSxDQUFDLFVBQVUsRUFBRSxDQUFDLFNBQVMsQ0FBQTtZQUMzQyxNQUFNLEdBQUcsR0FBRyxnREFBZ0QsQ0FBQTtZQUM1RCxNQUFNLE9BQU8sR0FBRyxJQUFJLENBQUMsTUFBTSxDQUFDLEdBQUcsQ0FBQyxHQUFHLENBQUMsQ0FBQTtZQUNwQyxFQUFFLENBQUMsQ0FBQyxDQUFDLEtBQUssQ0FBQyxDQUFDLENBQUM7Z0JBQ1gsSUFBSSxDQUFDLGFBQWEsQ0FBQyxRQUFRLENBQUMsMENBQTBDLENBQUMsQ0FBQTtZQUN6RSxDQUFDO1lBQUMsSUFBSSxDQUFDLEVBQUUsQ0FBQyxDQUFDLE9BQU8sQ0FBQyxRQUFRLENBQUMsS0FBSyxDQUFDLENBQUMsQ0FBQyxDQUFDO2dCQUNuQyxJQUFJLENBQUMsYUFBYSxDQUFDLFVBQVUsQ0FBQyxHQUFHLEtBQUssOEJBQThCLENBQUMsQ0FBQTtZQUN2RSxDQUFDO1lBQUMsSUFBSSxDQUFDLENBQUM7Z0JBQ04sSUFBSSxDQUFDLE1BQU0sQ0FBQyxHQUFHLENBQUMsR0FBRyxFQUFFLENBQUMsR0FBRyxPQUFPLEVBQUUsS0FBSyxDQUFDLENBQUMsQ0FBQTtnQkFDekMsSUFBSSxDQUFDLGFBQWEsQ0FBQyxVQUFVLENBQzNCLHNCQUFzQixLQUFLLHFCQUFxQixDQUNqRCxDQUFBO1lBQ0gsQ0FBQztRQUNILENBQUM7S0FDRixDQUFDLENBQUE7QUFDSixDQUFDO0FBekJELDRCQXlCQztBQUVEO0lBQ0UsT0FBTyxDQUFDLE9BQU8sRUFBRSxDQUFBO0lBQ2pCLGNBQWMsQ0FBQyxPQUFPLEVBQUUsQ0FBQTtBQUMxQixDQUFDO0FBSEQsZ0NBR0MiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBUYWJsZUZvcm1hdHRlciB9IGZyb20gJy4vdGFibGUtZm9ybWF0dGVyJ1xuaW1wb3J0IHsgRGlzcG9zYWJsZSB9IGZyb20gJ2F0b20nXG5leHBvcnQgeyBjb25maWcgfSBmcm9tICcuL2NvbmZpZydcblxubGV0IHRhYmxlRm9ybWF0dGVyOiBUYWJsZUZvcm1hdHRlclxubGV0IGNvbW1hbmQ6IERpc3Bvc2FibGVcblxuZXhwb3J0IGZ1bmN0aW9uIGFjdGl2YXRlKCkge1xuICB0YWJsZUZvcm1hdHRlciA9IG5ldyBUYWJsZUZvcm1hdHRlcigpXG4gIC8vIFJlZ2lzdGVyIGNvbW1hbmQgdG8gd29ya3NwYWNlXG4gIGNvbW1hbmQgPSBhdG9tLmNvbW1hbmRzLmFkZCgnYXRvbS10ZXh0LWVkaXRvcicsIHtcbiAgICAnbWFya2Rvd24tdGFibGUtZm9ybWF0dGVyOmZvcm1hdCc6IGV2ZW50ID0+IHtcbiAgICAgIGNvbnN0IGVkaXRvciA9IGV2ZW50LmN1cnJlbnRUYXJnZXQuZ2V0TW9kZWwoKVxuICAgICAgdGFibGVGb3JtYXR0ZXIuZm9ybWF0KGVkaXRvcilcbiAgICB9LFxuICAgICdtYXJrZG93bi10YWJsZS1mb3JtYXR0ZXI6ZW5hYmxlLWZvci1jdXJyZW50LXNjb3BlJyhldmVudCkge1xuICAgICAgY29uc3QgZWRpdG9yID0gZXZlbnQuY3VycmVudFRhcmdldC5nZXRNb2RlbCgpXG4gICAgICBjb25zdCBzY29wZSA9IGVkaXRvci5nZXRHcmFtbWFyKCkuc2NvcGVOYW1lXG4gICAgICBjb25zdCBrZXkgPSAnbWFya2Rvd24tdGFibGUtZm9ybWF0dGVyLm1hcmtkb3duR3JhbW1hclNjb3BlcydcbiAgICAgIGNvbnN0IGN1cnJlbnQgPSBhdG9tLmNvbmZpZy5nZXQoa2V5KVxuICAgICAgaWYgKCFzY29wZSkge1xuICAgICAgICBhdG9tLm5vdGlmaWNhdGlvbnMuYWRkRXJyb3IoJ0NvdWxkIG5vdCBkZXRlcm1pbmUgZWRpdG9yIGdyYW1tYXIgc2NvcGUnKVxuICAgICAgfSBlbHNlIGlmIChjdXJyZW50LmluY2x1ZGVzKHNjb3BlKSkge1xuICAgICAgICBhdG9tLm5vdGlmaWNhdGlvbnMuYWRkV2FybmluZyhgJHtzY29wZX0gYWxyZWFkeSBjb25zaWRlcmVkIE1hcmtkb3duYClcbiAgICAgIH0gZWxzZSB7XG4gICAgICAgIGF0b20uY29uZmlnLnNldChrZXksIFsuLi5jdXJyZW50LCBzY29wZV0pXG4gICAgICAgIGF0b20ubm90aWZpY2F0aW9ucy5hZGRTdWNjZXNzKFxuICAgICAgICAgIGBTdWNjZXNzZnVsbHkgYWRkZWQgJHtzY29wZX0gdG8gTWFya2Rvd24gc2NvcGVzYCxcbiAgICAgICAgKVxuICAgICAgfVxuICAgIH0sXG4gIH0pXG59XG5cbmV4cG9ydCBmdW5jdGlvbiBkZWFjdGl2YXRlKCkge1xuICBjb21tYW5kLmRpc3Bvc2UoKVxuICB0YWJsZUZvcm1hdHRlci5kZXN0cm95KClcbn1cbiJdfQ==