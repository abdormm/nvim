---This is a ~~hack~~ fix for a completion issue that is present when using
---lemminx (with the maven extension) and blink.cmp. This fixes 2 issue:
---
---1. when completing dependencies from the maven centeral repo, the text is
---   inserted but the indentation is wrong. This is because of 2 reasons.
---   First, the text to be inserted is treated as a snippet. Second, the text
---   to be inserted has already the correct indentation. However, the default
---   `vim.snippet.expand`, adds the indentation of the base line. That is why
---   the first line is correct and the rest are overly indented. An example,
---   Here gizmo was selected:
---   ```xml
---     <dependency>
---         <groupId>org.springframework.boot</groupId>
---         <artifactId>spring-boot-starter-web</artifactId>
---     </dependency>
---     <dependency>
---                 <groupId>io.quarkus.gizmo</groupId>
---                 <artifactId>gizmo</artifactId>
---                 <version>1.0.11.Final</version>
---             </dependency>
---     <dependency>
---         <groupId>org.springframework.boot</groupId>
---         <artifactId>spring-boot-starter-data-jdbc</artifactId>
---     </dependency>
---   ```
---
---2. when completing property placeholder (example: `${activemq.version}`), it
---   is not inserted. It seems that it is also treated as a snippet since
---   `vim.snippet.expand` is called.
---
---The actual fix: try to guess non-snippets (any thing that does not have
---`$` followed by a digit) and set `item.insertTextFormat` to 1. Currently,
---based on my observations all the snippets send by this server follow this
---format, so this ~~hack~~ fix does work.
---@param method vim.lsp.protocol.Method.ClientToServer.Request
---@param params? table
---@param callback fun(err?: lsp.ResponseError, result: any, request_id: integer)
---@param notify_reply_callback? fun(message_id: integer)
---@return vim.lsp.protocol.Method.ClientToServer.Request
---@return table?
---@return fun(err?: lsp.ResponseError, result: any, request_id: integer)
---@return fun(message_id: integer)?
local completion_fix = function(method, params, callback, notify_reply_callback)
    local new_callback = callback

    if method == "textDocument/completion" then
        ---@param err? lsp.ResponseError
        ---@param result? vim.lsp.CompletionResult
        ---@param request_id integer
        new_callback = function(err, result, request_id)
            if err or not result then
                callback(err, result, request_id)
                return
            end
            for _, item in ipairs(result.items) do
                if item.textEditText and not item.textEditText:match("$%d") then
                    item.insertTextFormat = 1
                end
            end
            callback(err, result, request_id)
        end
    end

    return method, params, new_callback, notify_reply_callback
end

---@type vim.lsp.Config
return {
    cmd = function(dispatchers)
        local rpc_client = vim.lsp.rpc.start({ "lemminx" }, dispatchers)
        return require("util.lsp").rpc_client_interceptor(rpc_client, completion_fix)
    end,
}
