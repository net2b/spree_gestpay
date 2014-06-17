Deface::Override.new(
  virtual_path: "spree/checkout/_payment",
  name:         "disable_save_and_continue_button",
  replace:      ".form-buttons erb[loud]",
  text:         "<%= submit_tag t(:save_and_continue), :class => 'continue button primary', :disabled => true %>",
  original:     "<%= submit_tag t(:save_and_continue), :class => 'continue button primary' %>")
