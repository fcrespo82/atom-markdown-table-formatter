"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const table_formatter_1 = require("./table-formatter");
const wcswidth = require("wcwidth");
function swidth(str) {
    const zwcrx = /[\u200B-\u200D\uFEFF\u00AD]/g;
    const match = str.match(zwcrx);
    return wcswidth(str) - (match ? match.length : 0);
}
function padding(len, str = ' ') {
    return str.repeat(len);
}
const stripTailPipes = (str) => str.trim().replace(/(^\||\|$)/g, '');
const splitCells = (str) => str.split('|');
const addTailPipes = (str) => `|${str}|`;
const joinCells = (arr) => arr.join('|');
const tableJustMap = {
    Left: ':-',
    Center: '::',
    Right: '-:',
};
function formatTable(text, settings = table_formatter_1.getAllSettings()) {
    const addTailPipesIfNeeded = settings.keepFirstAndLastPipes
        ? addTailPipes
        : (x) => x;
    let formatline = text[2].trim();
    const headerline = text[1].trim();
    let formatrow;
    let data;
    if (headerline.length === 0) {
        formatrow = 0;
        data = text[3];
    }
    else {
        formatrow = 1;
        data = text[1] + text[3];
    }
    const lines = data.trim().split(/\r?\n/);
    const justify = splitCells(stripTailPipes(formatline)).map(cell => {
        const trimmed = cell.trim();
        const first = trimmed[0];
        const last = trimmed[trimmed.length - 1];
        const ends = (first || ':') + (last || '-');
        if (ends === '--')
            return tableJustMap[settings.defaultTableJustification];
        else
            return ends;
    });
    const columns = justify.length;
    const colArr = Array.from(Array(columns));
    const cellPadding = padding(settings.spacePadding);
    const content = lines.map(line => {
        const cells = splitCells(stripTailPipes(line));
        if (columns - cells.length > 0) {
            cells.push(...Array(columns - cells.length).fill(''));
        }
        else if (columns - cells.length < 0) {
            cells[columns - 1] = joinCells(cells.slice(columns - 1));
        }
        return cells.map(cell => `${cellPadding}${cell.trim()}${cellPadding}`);
    });
    const widths = colArr.map((_x, i) => Math.max(2, ...content.map(cells => swidth(cells[i]))));
    if (settings.limitLastColumnPadding) {
        const preferredLineLength = atom.config.get('editor.preferredLineLength');
        const sum = (arr) => arr.reduce((x, y) => x + y, 0);
        const wsum = sum(widths);
        if (wsum > preferredLineLength) {
            const prewsum = sum(widths.slice(0, -1));
            widths[widths.length - 1] = Math.max(preferredLineLength - prewsum - widths.length - 1, 3);
        }
    }
    const just = function (str, col) {
        const length = Math.max(widths[col] - swidth(str), 0);
        switch (justify[col]) {
            case '::':
                return padding(length / 2) + str + padding((length + 1) / 2);
            case '-:':
                return padding(length) + str;
            case ':-':
                return str + padding(length);
            default:
                throw new Error(`Unknown column justification ${justify[col]}`);
        }
    };
    const formatted = content.map(cells => addTailPipesIfNeeded(joinCells(colArr.map((_x, i) => just(cells[i], i)))));
    formatline = addTailPipesIfNeeded(joinCells(colArr.map((_x, i) => {
        const [front, back] = justify[i];
        return front + padding(widths[i] - 2, '-') + back;
    })));
    formatted.splice(formatrow, 0, formatline);
    return ((formatrow === 0 && text[1] !== '' ? '\n' : '') +
        formatted.join('\n') +
        '\n');
}
exports.formatTable = formatTable;
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZm9ybWF0VGFibGUuanMiLCJzb3VyY2VSb290IjoiIiwic291cmNlcyI6WyIuLi9zcmMvZm9ybWF0VGFibGUudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6Ijs7QUFBQSx1REFBa0Q7QUFDbEQsb0NBQW9DO0FBRXBDLGdCQUFnQixHQUFXO0lBR3pCLE1BQU0sS0FBSyxHQUFHLDhCQUE4QixDQUFBO0lBQzVDLE1BQU0sS0FBSyxHQUFHLEdBQUcsQ0FBQyxLQUFLLENBQUMsS0FBSyxDQUFDLENBQUE7SUFDOUIsTUFBTSxDQUFDLFFBQVEsQ0FBQyxHQUFHLENBQUMsR0FBRyxDQUFDLEtBQUssQ0FBQyxDQUFDLENBQUMsS0FBSyxDQUFDLE1BQU0sQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUE7QUFDbkQsQ0FBQztBQUVELGlCQUFpQixHQUFXLEVBQUUsTUFBYyxHQUFHO0lBQzdDLE1BQU0sQ0FBQyxHQUFHLENBQUMsTUFBTSxDQUFDLEdBQUcsQ0FBQyxDQUFBO0FBQ3hCLENBQUM7QUFDRCxNQUFNLGNBQWMsR0FBRyxDQUFDLEdBQVcsRUFBRSxFQUFFLENBQUMsR0FBRyxDQUFDLElBQUksRUFBRSxDQUFDLE9BQU8sQ0FBQyxZQUFZLEVBQUUsRUFBRSxDQUFDLENBQUE7QUFDNUUsTUFBTSxVQUFVLEdBQUcsQ0FBQyxHQUFXLEVBQUUsRUFBRSxDQUFDLEdBQUcsQ0FBQyxLQUFLLENBQUMsR0FBRyxDQUFDLENBQUE7QUFDbEQsTUFBTSxZQUFZLEdBQUcsQ0FBQyxHQUFXLEVBQUUsRUFBRSxDQUFDLElBQUksR0FBRyxHQUFHLENBQUE7QUFDaEQsTUFBTSxTQUFTLEdBQUcsQ0FBQyxHQUFhLEVBQUUsRUFBRSxDQUFDLEdBQUcsQ0FBQyxJQUFJLENBQUMsR0FBRyxDQUFDLENBQUE7QUFFbEQsTUFBTSxZQUFZLEdBQUc7SUFDbkIsSUFBSSxFQUFFLElBQUk7SUFDVixNQUFNLEVBQUUsSUFBSTtJQUNaLEtBQUssRUFBRSxJQUFJO0NBQ1osQ0FBQTtBQUVELHFCQUNFLElB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QUMsS0FBSyxFQUFFLElBQUksQ0FBQyxHQUFHLE9BQU8sQ0FBQyxDQUFDLENBQUMsQ0FBQTtRQUNoQyxNQUFNLENBQUMsS0FBSyxHQUFHLE9BQU8sQ0FBQyxNQUFNLENBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxFQUFFLEdBQUcsQ0FBQyxHQUFHLElBQUksQ0FBQTtJQUNuRCxDQUFDLENBQUMsQ0FDSCxDQUNGLENBQUE7SUFFRCxTQUFTLENBQUMsTUFBTSxDQUFDLFNBQVMsRUFBRSxDQUFDLEVBQUUsVUFBVSxDQUFDLENBQUE7SUFFMUMsTUFBTSxDQUFDLENBQ0wsQ0FBQyxTQUFTLEtBQUssQ0FBQyxJQUFJLElBQUksQ0FBQyxDQUFDLENBQUMsS0FBSyxFQUFFLENBQUMsQ0FBQyxDQUFDLElBQUksQ0FBQyxDQUFDLENBQUMsRUFBRSxDQUFDO1FBQy9DLFNBQVMsQ0FBQyxJQUFJLENBQUMsSUFBSSxDQUFDO1FBQ3BCLElBQUksQ0FDTCxDQUFBO0FBQ0gsQ0FBQztBQXBHRCxrQ0FvR0MiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQgeyBnZXRBbGxTZXR0aW5ncyB9IGZyb20gJy4vdGFibGUtZm9ybWF0dGVyJ1xuaW1wb3J0IHdjc3dpZHRoID0gcmVxdWlyZSgnd2N3aWR0aCcpXG5cbmZ1bmN0aW9uIHN3aWR0aChzdHI6IHN0cmluZykge1xuICAvLyB6ZXJvLXdpZHRoIFVuaWNvZGUgY2hhcmFjdGVycyB0aGF0IHdlIHNob3VsZCBpZ25vcmUgZm9yXG4gIC8vIHB1cnBvc2VzIG9mIGNvbXB1dGluZyBzdHJpbmcgXCJkaXNwbGF5XCIgd2lkdGhcbiAgY29uc3QgendjcnggPSAvW1xcdTIwMEItXFx1MjAwRFxcdUZFRkZcXHUwMEFEXS9nXG4gIGNvbnN0IG1hdGNoID0gc3RyLm1hdGNoKHp3Y3J4KVxuICByZXR1cm4gd2Nzd2lkdGgoc3RyKSAtIChtYXRjaCA/IG1hdGNoLmxlbmd0aCA6IDApXG59XG5cbmZ1bmN0aW9uIHBhZGRpbmcobGVuOiBudW1iZXIsIHN0cjogc3RyaW5nID0gJyAnKSB7XG4gIHJldHVybiBzdHIucmVwZWF0KGxlbilcbn1cbmNvbnN0IHN0cmlwVGFpbFBpcGVzID0gKHN0cjogc3RyaW5nKSA9PiBzdHIudHJpbSgpLnJlcGxhY2UoLyheXFx8fFxcfCQpL2csICcnKVxuY29uc3Qgc3BsaXRDZWxscyA9IChzdHI6IHN0cmluZykgPT4gc3RyLnNwbGl0KCd8JylcbmNvbnN0IGFkZFRhaWxQaXBlcyA9IChzdHI6IHN0cmluZykgPT4gYHwke3N0cn18YFxuY29uc3Qgam9pbkNlbGxzID0gKGFycjogc3RyaW5nW10pID0+IGFyci5qb2luKCd8JylcblxuY29uc3QgdGFibGVKdXN0TWFwID0ge1xuICBMZWZ0OiAnOi0nLFxuICBDZW50ZXI6ICc6OicsXG4gIFJpZ2h0OiAnLTonLFxufVxuXG5leHBvcnQgZnVuY3Rpb24gZm9ybWF0VGFibGUoXG4gIHRleHQ6IFJlZ0V4cEV4ZWNBcnJheSxcbiAgc2V0dGluZ3MgPSBnZXRBbGxTZXR0aW5ncygpLFxuKSB7XG4gIGNvbnN0IGFkZFRhaWxQaXBlc0lmTmVlZGVkID0gc2V0dGluZ3Mua2VlcEZpcnN0QW5kTGFzdFBpcGVzXG4gICAgPyBhZGRUYWlsUGlwZXNcbiAgICA6ICh4OiBzdHJpbmcpID0+IHhcblxuICBsZXQgZm9ybWF0bGluZSA9IHRleHRbMl0udHJpbSgpXG4gIGNvbnN0IGhlYWRlcmxpbmUgPSB0ZXh0WzFdLnRyaW0oKVxuXG4gIGxldCBmb3JtYXRyb3c6IG51bWJlclxuICBsZXQgZGF0YTogc3RyaW5nXG4gIGlmIChoZWFkZXJsaW5lLmxlbmd0aCA9PT0gMCkge1xuICAgIGZvcm1hdHJvdyA9IDBcbiAgICBkYXRhID0gdGV4dFszXVxuICB9IGVsc2Uge1xuICAgIGZvcm1hdHJvdyA9IDFcbiAgICBkYXRhID0gdGV4dFsxXSArIHRleHRbM11cbiAgfVxuICBjb25zdCBsaW5lcyA9IGRhdGEudHJpbSgpLnNwbGl0KC9cXHI/XFxuLylcblxuICBjb25zdCBqdXN0aWZ5ID0gc3BsaXRDZWxscyhzdHJpcFRhaWxQaXBlcyhmb3JtYXRsaW5lKSkubWFwKGNlbGwgPT4ge1xuICAgIGNvbnN0IHRyaW1tZWQgPSBjZWxsLnRyaW0oKVxuICAgIGNvbnN0IGZpcnN0ID0gdHJpbW1lZFswXVxuICAgIGNvbnN0IGxhc3QgPSB0cmltbWVkW3RyaW1tZWQubGVuZ3RoIC0gMV1cbiAgICBjb25zdCBlbmRzID0gKGZpcnN0IHx8ICc6JykgKyAobGFzdCB8fCAnLScpXG4gICAgaWYgKGVuZHMgPT09ICctLScpIHJldHVybiB0YWJsZUp1c3RNYXBbc2V0dGluZ3MuZGVmYXVsdFRhYmxlSnVzdGlmaWNhdGlvbl1cbiAgICBlbHNlIHJldHVybiBlbmRzXG4gIH0pXG5cbiAgY29uc3QgY29sdW1ucyA9IGp1c3RpZnkubGVuZ3RoXG4gIGNvbnN0IGNvbEFycjogdW5kZWZpbmVkW10gPSBBcnJheS5mcm9tKEFycmF5KGNvbHVtbnMpKVxuXG4gIGNvbnN0IGNlbGxQYWRkaW5nID0gcGFkZGluZyhzZXR0aW5ncy5zcGFjZVBhZGRpbmcpXG5cbiAgY29uc3QgY29udGVudCA9IGxpbmVzLm1hcChsaW5lID0+IHtcbiAgICBjb25zdCBjZWxscyA9IHNwbGl0Q2VsbHMoc3RyaXBUYWlsUGlwZXMobGluZSkpXG4gICAgaWYgKGNvbHVtbnMgLSBjZWxscy5sZW5ndGggPiAwKSB7XG4gICAgICAvLyBwYWQgcm93cyB0byBoYXZlIGBjb2x1bW5zYCBjZWxsc1xuICAgICAgY2VsbHMucHVzaCguLi5BcnJheShjb2x1bW5zIC0gY2VsbHMubGVuZ3RoKS5maWxsKCcnKSlcbiAgICB9IGVsc2UgaWYgKGNvbHVtbnMgLSBjZWxscy5sZW5ndGggPCAwKSB7XG4gICAgICAvLyBwdXQgYWxsIGV4dHJhIGNvbnRlbnQgaW50byBsYXN0IGNlbGxcbiAgICAgIGNlbGxzW2NvbHVtbnMgLSAxXSA9IGpvaW5DZWxscyhjZWxscy5zbGljZShjb2x1bW5zIC0gMSkpXG4gICAgfVxuICAgIHJldHVybiBjZWxscy5tYXAoY2VsbCA9PiBgJHtjZWxsUGFkZGluZ30ke2NlbGwudHJpbSgpfSR7Y2VsbFBhZGRpbmd9YClcbiAgfSlcblxuICBjb25zdCB3aWR0aHMgPSBjb2xBcnIubWFwKChfeCwgaSkgPT5cbiAgICBNYXRoLm1heCgyLCAuLi5jb250ZW50Lm1hcChjZWxscyA9PiBzd2lkdGgoY2VsbHNbaV0pKSksXG4gIClcblxuICBpZiAoc2V0dGluZ3MubGltaXRMYXN0Q29sdW1uUGFkZGluZykge1xuICAgIGNvbnN0IHByZWZlcnJlZExpbmVMZW5ndGggPSBhdG9tLmNvbmZpZy5nZXQoJ2VkaXRvci5wcmVmZXJyZWRMaW5lTGVuZ3RoJylcbiAgICBjb25zdCBzdW0gPSAoYXJyOiBudW1iZXJbXSkgPT4gYXJyLnJlZHVjZSgoeCwgeSkgPT4geCArIHksIDApXG4gICAgY29uc3Qgd3N1bSA9IHN1bSh3aWR0aHMpXG4gICAgaWYgKHdzdW0gPiBwcmVmZXJyZWRMaW5lTGVuZ3RoKSB7XG4gICAgICBjb25zdCBwcmV3c3VtID0gc3VtKHdpZHRocy5zbGljZSgwLCAtMSkpXG4gICAgICB3aWR0aHNbd2lkdGhzLmxlbmd0aCAtIDFdID0gTWF0aC5tYXgoXG4gICAgICAgIHByZWZlcnJlZExpbmVMZW5ndGggLSBwcmV3c3VtIC0gd2lkdGhzLmxlbmd0aCAtIDEsXG4gICAgICAgIDMsXG4gICAgICApXG4gICAgICAvLyBOZWVkIGF0IGxlYXN0IDotLSBmb3IgZ2l0aHViIHRvIHJlY29nbml6ZSBhIGNvbHVtblxuICAgIH1cbiAgfVxuXG4gIGNvbnN0IGp1c3QgPSBmdW5jdGlvbihzdHI6IHN0cmluZywgY29sOiBudW1iZXIpIHtcbiAgICBjb25zdCBsZW5ndGggPSBNYXRoLm1heCh3aWR0aHNbY29sXSAtIHN3aWR0aChzdHIpLCAwKVxuICAgIHN3aXRjaCAoanVzdGlmeVtjb2xdKSB7XG4gICAgICBjYXNlICc6Oic6XG4gICAgICAgIHJldHVybiBwYWRkaW5nKGxlbmd0aCAvIDIpICsgc3RyICsgcGFkZGluZygobGVuZ3RoICsgMSkgLyAyKVxuICAgICAgY2FzZSAnLTonOlxuICAgICAgICByZXR1cm4gcGFkZGluZyhsZW5ndGgpICsgc3RyXG4gICAgICBjYXNlICc6LSc6XG4gICAgICAgIHJldHVybiBzdHIgKyBwYWRkaW5nKGxlbmd0aClcbiAgICAgIGRlZmF1bHQ6XG4gICAgICAgIHRocm93IG5ldyBFcnJvcihgVW5rbm93biBjb2x1bW4ganVzdGlmaWNhdGlvbiAke2p1c3RpZnlbY29sXX1gKVxuICAgIH1cbiAgfVxuXG4gIGNvbnN0IGZvcm1hdHRlZCA9IGNvbnRlbnQubWFwKGNlbGxzID0+XG4gICAgYWRkVGFpbFBpcGVzSWZOZWVkZWQoam9pbkNlbGxzKGNvbEFyci5tYXAoKF94LCBpKSA9PiBqdXN0KGNlbGxzW2ldLCBpKSkpKSxcbiAgKVxuXG4gIGZvcm1hdGxpbmUgPSBhZGRUYWlsUGlwZXNJZk5lZWRlZChcbiAgICBqb2luQ2VsbHMoXG4gICAgICBjb2xBcnIubWFwKChfeCwgaSkgPT4ge1xuICAgICAgICBjb25zdCBbZnJvbnQsIGJhY2tdID0ganVzdGlmeVtpXVxuICAgICAgICByZXR1cm4gZnJvbnQgKyBwYWRkaW5nKHdpZHRoc1tpXSAtIDIsICctJykgKyBiYWNrXG4gICAgICB9KSxcbiAgICApLFxuICApXG5cbiAgZm9ybWF0dGVkLnNwbGljZShmb3JtYXRyb3csIDAsIGZvcm1hdGxpbmUpXG5cbiAgcmV0dXJuIChcbiAgICAoZm9ybWF0cm93ID09PSAwICYmIHRleHRbMV0gIT09ICcnID8gJ1xcbicgOiAnJykgK1xuICAgIGZvcm1hdHRlZC5qb2luKCdcXG4nKSArXG4gICAgJ1xcbidcbiAgKVxufVxuIl19