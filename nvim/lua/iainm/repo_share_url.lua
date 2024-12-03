local Job = require("plenary.job")

local function get_repo_root()
	local result = Job:new({
		command = "git",
		args = { "rev-parse", "--show-toplevel" },
		cwd = vim.fn.expand("%:p:h"),
	}):sync()
	return result[1]
end

local function get_current_branch()
	local result = Job:new({
		command = "git",
		args = { "rev-parse", "--abbrev-ref", "HEAD" },
		cwd = vim.fn.expand("%:p:h"),
	}):sync()
	return result[1]
end

local function get_remote_url()
	local result = Job:new({
		command = "git",
		args = { "config", "--get", "remote.origin.url" },
		cwd = vim.fn.expand("%:p:h"),
	}):sync()
	return result[1]
end

local function parse_remote_url(remote_url)
	if remote_url:find("github.com") then
		return "github", remote_url:gsub("git@github.com:", "https://github.com/"):gsub("%.git$", "")
	elseif remote_url:find("gitlab.com") then
		return "gitlab", remote_url:gsub("git@gitlab.com:", "https://gitlab.com/"):gsub("%.git$", "")
	elseif remote_url:find("bitbucket.org") then
		return "bitbucket", remote_url:gsub("git@bitbucket.org:", "https://bitbucket.org/"):gsub("%.git$", "")
	else
		return nil, nil
	end
end

local function generate_share_url()
	local repo_root = get_repo_root()
	local current_branch = get_current_branch()
	local remote_url = get_remote_url()
	local file_path = vim.fn.expand("%:p")
	local relative_path = file_path:sub(#repo_root + 2)
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local platform, base_url = parse_remote_url(remote_url)
	if not platform then
		print("Unsupported remote URL")
		return
	end

	local share_url
	if platform == "github" or platform == "gitlab" then
		share_url =
			string.format("%s/blob/%s/%s#L%d-L%d", base_url, current_branch, relative_path, start_line, end_line)
	elseif platform == "bitbucket" then
		share_url =
			string.format("%s/src/%s/%s#lines-%d:%d", base_url, current_branch, relative_path, start_line, end_line)
	end

	vim.fn.setreg("+", share_url)
	print("Share URL copied to clipboard: " .. share_url)
end

vim.keymap.set(
	"v",
	"<leader>gu",
	generate_share_url,
	{ noremap = true, silent = true, desc = "[G]enerate block share [U]RL" }
)

vim.keymap.set(
	"n",
	"<leader>gu",
	generate_share_url,
	{ noremap = true, silent = true, desc = "[G]enerate file share [U]RL" }
)
