local function url_encode(str)
  str = string.gsub(str, "([^%w _.-])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  str = string.gsub(str, " ", "%%20")
  return str
end

local function open_in_obsidian()
  local vaults_path = os.getenv("VAULTS_PATH")
  if not vaults_path or vaults_path == "" then
    print("Error: VAULTS_PATH environment variable not set.")
    return
  end

  -- Normalize vaults_path by removing any trailing slash
  local normalized_vault_path = vaults_path:gsub("/$", "")

  local file_path = vim.fn.expand('%:p')
  if vim.bo.filetype ~= 'markdown' then
    print("Not a markdown file.")
    return
  end

  if not file_path:find(normalized_vault_path, 1, true) then
    print("Error: File is not in the Obsidian vault.")
    return
  end

  local vault_name = vim.fn.fnamemodify(normalized_vault_path, ':t')
  -- Create the prefix to remove from the file path to get the relative path
  local prefix = normalized_vault_path .. '/'
  local relative_path = file_path:gsub(prefix, '', 1) -- only replace the first occurrence

  -- The file parameter in the URI is often specified without the .md extension
  relative_path = relative_path:gsub('%.md$', '')

  local uri = "obsidian://open?vault=" .. url_encode(vault_name) .. "&file=" .. url_encode(relative_path)
  local command = 'open "' .. uri .. '"'
  os.execute(command)
end

vim.api.nvim_create_user_command('OpenInObsidian', open_in_obsidian, {})

local function create_long_term_todo()
  local vaults_path = os.getenv("VAULTS_PATH")
  if not vaults_path or vaults_path == "" then
    print("Error: VAULTS_PATH environment variable not set.")
    return
  end

  -- Normalize vaults_path by removing any trailing slash
  local normalized_vault_path = vaults_path:gsub("/$", "")

  -- Read the template file
  local template_path = normalized_vault_path .. "/templates/long_term_todo.md"
  local template_file = io.open(template_path, "r")
  if not template_file then
    print("Error: Template file not found at " .. template_path)
    return
  end
  local template_content = template_file:read("*all")
  template_file:close()

  -- Prompt for the todo name
  local input = vim.fn.input("Long-term todo name: ")
  if input == nil or input == "" then
    print("Error: A todo name must be set.")
    return
  end

  -- Format the name (replace spaces with underscores)
  local formatted_name = string.gsub(input, " ", "_")

  -- Generate filename with date prefix
  local timestamp = os.date("%Y_%m_%d")
  local filename = timestamp .. "_" .. formatted_name .. ".md"
  local file_path = normalized_vault_path .. "/notes/long_term_todos/" .. filename

  -- Ensure the directory exists
  local dir_path = normalized_vault_path .. "/notes/long_term_todos"
  vim.fn.mkdir(dir_path, "p")

  -- Write the template content to the new file
  local new_file = io.open(file_path, "w")
  if not new_file then
    print("Error: Could not create file at " .. file_path)
    return
  end
  new_file:write(template_content)
  new_file:close()

  -- Open the new file for editing
  vim.cmd("edit " .. file_path)
  print("Created long-term todo: " .. filename)
end

vim.api.nvim_create_user_command('ObsidianLongTermTodo', create_long_term_todo, {})