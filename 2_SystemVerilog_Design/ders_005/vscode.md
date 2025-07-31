  // Customize formatting command to suite preferences
  //--class_member_variables_alignment=infer
  //--net_variable_alignment=preserve
  "systemverilog.formatCommand": "verible-verilog-format --indentation_spaces=2 --column_limit 200 --assignment_statement_alignment=infer --case_items_alignment=align --module_net_variable_alignment=align --named_parameter_alignment=align --named_port_alignment=align --named_port_indentation=wrap --port_declarations_alignment=infer",
  // Add additional file extensions to associate with SystemVerilog and include them in the indexing
   "files.associations": {
    "*.sv": "systemverilog",
    "*.svh": "systemverilog",
    "*.v": "systemverilog",
    "*.vh": "systemverilog",
    "*.svi": "systemverilog",
    "*.svp": "systemverilog",
    "*.pkg": "systemverilog"
  },
  "systemverilog.includeIndexing": [
    "**/*.{sv,v,svh,vh,svi,svp,pkg}"
  ],
  "[systemverilog]": {
  "editor.defaultFormatter": "eirikpre.systemverilog",
  "editor.formatOnSave": true
  },
  "terminal.integrated.windowsEnableConpty": false,
  "systemverilog.compileOnSave": true,
  "systemverilog.disableIndexing": true,
  "systemverilog.forceFastIndexing": true,
  "extensions.ignoreRecommendations": true,
  "workbench.colorTheme": "Adapta Nokto",
  "animations.Enabled": true,
  "vscode_custom_css.imports": [
    "file:///home/kerim/.vscode/extensions/brandonkirbyson.vscode-animations-2.0.3/dist/updateHandler.js"
  ],
  "window.titleBarStyle": "true",
  "[verilog]": {
    "editor.defaultFormatter": "kukdh1.verible-formatter"
  }