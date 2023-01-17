local config = {
    cmd = { '/opt/homebrew/bin/jdtls' },
    root_dir = vim.fs.dirname(vim.fs.find({ '.gradlew', '.git', 'mvnw', 'pom.xml' }, { upward = true })[1]),
    -- settings = {
    --     java = {
    --         configuration = {
    --             runtimes = {
    --                 {
    --                     name = 'JavaSE-8',
    --                     path = '',
    --                 },
    --                 {
    --                     name = 'JavaSE-11',
    --                     path = '',
    --                 },
    --                 {
    --                     name = 'JavaSE-17',
    --                     path = '',
    --                 },
    --                 {
    --                     name = 'JavaSE-19',
    --                     path = '',
    --                 },
    --             }
    --         }
    --     }
    -- }
}
require('jdtls').start_or_attach(config)
