"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = {
    formatOnSave: {
        type: 'boolean',
        default: true,
        description: 'Format tables when document is saved?',
    },
    autoSelectEntireDocument: {
        type: 'boolean',
        default: true,
        description: 'Select entire document if selection is empty',
    },
    spacePadding: {
        type: 'integer',
        default: 1,
        description: 'How many spaces between left and right of each column content',
    },
    keepFirstAndLastPipes: {
        type: 'boolean',
        default: true,
        description: `Keep first and last pipes "|" in table formatting. \
Tables are easier to format when pipes are kept`,
    },
    defaultTableJustification: {
        type: 'string',
        default: 'Left',
        enum: ['Left', 'Center', 'Right'],
        description: `Defines the default justification for tables that have only a \
\'-\' on the formatting line`,
    },
    markdownGrammarScopes: {
        type: 'array',
        default: ['source.gfm'],
        description: `File grammar scopes that will be considered Markdown by this package (comma-separated). \
Run \'Markdown Table Formatter: Enable For Current Scope\' command to \
add current editor grammar to this setting.`,
        items: {
            type: 'string',
        },
    },
    limitLastColumnPadding: {
        type: 'boolean',
        default: false,
        description: `Do not pad the last column to more than your editor\'s \
preferredLineLength setting.`,
    },
};
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiY29uZmlnLmpzIiwic291cmNlUm9vdCI6IiIsInNvdXJjZXMiOlsiLi4vc3JjL2NvbmZpZy50cyJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiOztBQUFhLFFBQUEsTUFBTSxHQUFHO0lBQ3BCLFlBQVksRUFBRTtRQUNaLElBQUksRUFBRSxTQUFTO1FBQ2YsT0FBTyxFQUFFLElBQUk7UUFDYixXQUFXLEVBQUUsdUNBQXVDO0tBQ3JEO0lBQ0Qsd0JBQXdCLEVBQUU7UUFDeEIsSUFBSSxFQUFFLFNBQVM7UUFDZixPQUFPLEVBQUUsSUFBSTtRQUNiLFdBQVcsRUFBRSw4Q0FBOEM7S0FDNUQ7SUFDRCxZQUFZLEVBQUU7UUFDWixJQUFJLEVBQUUsU0FBUztRQUNmLE9BQU8sRUFBRSxDQUFDO1FBQ1YsV0FBVyxFQUNULCtEQUErRDtLQUNsRTtJQUNELHFCQUFxQixFQUFFO1FBQ3JCLElBQUksRUFBRSxTQUFTO1FBQ2YsT0FBTyxFQUFFLElBQUk7UUFDYixXQUFXLEVBQUU7Z0RBQytCO0tBQzdDO0lBQ0QseUJBQXlCLEVBQUU7UUFDekIsSUFBSSxFQUFFLFFBQVE7UUFDZCxPQUFPLEVBQUUsTUFBTTtRQUNmLElBQUksRUFBRSxDQUFDLE1BQU0sRUFBRSxRQUFRLEVBQUUsT0FBTyxDQUFDO1FBQ2pDLFdBQVcsRUFBRTs2QkFDWTtLQUMxQjtJQUNELHFCQUFxQixFQUFFO1FBQ3JCLElBQUksRUFBRSxPQUFPO1FBQ2IsT0FBTyxFQUFFLENBQUMsWUFBWSxDQUFDO1FBQ3ZCLFdBQVcsRUFBRTs7NENBRTJCO1FBQ3hDLEtBQUssRUFBRTtZQUNMLElBQUksRUFBRSxRQUFRO1NBQ2Y7S0FDRjtJQUNELHNCQUFzQixFQUFFO1FBQ3RCLElBQUksRUFBRSxTQUFTO1FBQ2YsT0FBTyxFQUFFLEtBQUs7UUFDZCxXQUFXLEVBQUU7NkJBQ1k7S0FDMUI7Q0FDRixDQUFBIiwic291cmNlc0NvbnRlbnQiOlsiZXhwb3J0IGNvbnN0IGNvbmZpZyA9IHtcbiAgZm9ybWF0T25TYXZlOiB7XG4gICAgdHlwZTogJ2Jvb2xlYW4nLFxuICAgIGRlZmF1bHQ6IHRydWUsXG4gICAgZGVzY3JpcHRpb246ICdGb3JtYXQgdGFibGVzIHdoZW4gZG9jdW1lbnQgaXMgc2F2ZWQ/JyxcbiAgfSxcbiAgYXV0b1NlbGVjdEVudGlyZURvY3VtZW50OiB7XG4gICAgdHlwZTogJ2Jvb2xlYW4nLFxuICAgIGRlZmF1bHQ6IHRydWUsXG4gICAgZGVzY3JpcHRpb246ICdTZWxlY3QgZW50aXJlIGRvY3VtZW50IGlmIHNlbGVjdGlvbiBpcyBlbXB0eScsXG4gIH0sXG4gIHNwYWNlUGFkZGluZzoge1xuICAgIHR5cGU6ICdpbnRlZ2VyJyxcbiAgICBkZWZhdWx0OiAxLFxuICAgIGRlc2NyaXB0aW9uOlxuICAgICAgJ0hvdyBtYW55IHNwYWNlcyBiZXR3ZWVuIGxlZnQgYW5kIHJpZ2h0IG9mIGVhY2ggY29sdW1uIGNvbnRlbnQnLFxuICB9LFxuICBrZWVwRmlyc3RBbmRMYXN0UGlwZXM6IHtcbiAgICB0eXBlOiAnYm9vbGVhbicsXG4gICAgZGVmYXVsdDogdHJ1ZSxcbiAgICBkZXNjcmlwdGlvbjogYEtlZXAgZmlyc3QgYW5kIGxhc3QgcGlwZXMgXCJ8XCIgaW4gdGFibGUgZm9ybWF0dGluZy4gXFxcblRhYmxlcyBhcmUgZWFzaWVyIHRvIGZvcm1hdCB3aGVuIHBpcGVzIGFyZSBrZXB0YCxcbiAgfSxcbiAgZGVmYXVsdFRhYmxlSnVzdGlmaWNhdGlvbjoge1xuICAgIHR5cGU6ICdzdHJpbmcnLFxuICAgIGRlZmF1bHQ6ICdMZWZ0JyxcbiAgICBlbnVtOiBbJ0xlZnQnLCAnQ2VudGVyJywgJ1JpZ2h0J10sXG4gICAgZGVzY3JpcHRpb246IGBEZWZpbmVzIHRoZSBkZWZhdWx0IGp1c3RpZmljYXRpb24gZm9yIHRhYmxlcyB0aGF0IGhhdmUgb25seSBhIFxcXG5cXCctXFwnIG9uIHRoZSBmb3JtYXR0aW5nIGxpbmVgLFxuICB9LFxuICBtYXJrZG93bkdyYW1tYXJTY29wZXM6IHtcbiAgICB0eXBlOiAnYXJyYXknLFxuICAgIGRlZmF1bHQ6IFsnc291cmNlLmdmbSddLFxuICAgIGRlc2NyaXB0aW9uOiBgRmlsZSBncmFtbWFyIHNjb3BlcyB0aGF0IHdpbGwgYmUgY29uc2lkZXJlZCBNYXJrZG93biBieSB0aGlzIHBhY2thZ2UgKGNvbW1hLXNlcGFyYXRlZCkuIFxcXG5SdW4gXFwnTWFya2Rvd24gVGFibGUgRm9ybWF0dGVyOiBFbmFibGUgRm9yIEN1cnJlbnQgU2NvcGVcXCcgY29tbWFuZCB0byBcXFxuYWRkIGN1cnJlbnQgZWRpdG9yIGdyYW1tYXIgdG8gdGhpcyBzZXR0aW5nLmAsXG4gICAgaXRlbXM6IHtcbiAgICAgIHR5cGU6ICdzdHJpbmcnLFxuICAgIH0sXG4gIH0sXG4gIGxpbWl0TGFzdENvbHVtblBhZGRpbmc6IHtcbiAgICB0eXBlOiAnYm9vbGVhbicsXG4gICAgZGVmYXVsdDogZmFsc2UsXG4gICAgZGVzY3JpcHRpb246IGBEbyBub3QgcGFkIHRoZSBsYXN0IGNvbHVtbiB0byBtb3JlIHRoYW4geW91ciBlZGl0b3JcXCdzIFxcXG5wcmVmZXJyZWRMaW5lTGVuZ3RoIHNldHRpbmcuYCxcbiAgfSxcbn1cbiJdfQ==