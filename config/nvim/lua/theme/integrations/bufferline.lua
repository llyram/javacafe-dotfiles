local M = {}

function M.get(cp)
	return {
		BufferLineFill = { fg = cp.black1, bg = cp.black1 },
		BufferLineBackground = { fg = cp.gray0, bg = cp.black1 },
		BufferLineBufferVisible = { fg = cp.gray0, bg = cp.black2 },
		BufferLineBufferSelected = { fg = cp.white, bg = cp.black2, style = "italic" },
		BufferLineTabSelected = { fg = cp.red, bg = cp.blue },
		BufferLineTabClose = { fg = cp.red, bg = cp.black1 },
		BufferLineIndicatorSelected = { fg = cp.peach, bg = cp.black2 },
		BufferLineModified = { bg = cp.black1 },
		BufferLineModifiedVisible = { bg = cp.black2 },
		BufferLineSeparator = { fg = cp.black1, bg = cp.black1 },
		BufferLineSeparatorVisible = { fg = cp.black1, bg = cp.black1 },
		BufferLineSeparatorSelected = { fg = cp.black1, bg = cp.black1 },
		BufferLineCloseButton = { fg = cp.black4, bg = cp.black1 },
		BufferLineCloseButtonVisible = { fg = cp.black4, bg = cp.black2 },
		BufferLineCloseButtonSelected = { fg = cp.gray0, bg = cp.black2 },
	}
end

return M
