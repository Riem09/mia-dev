def accept_dialog
  page.evaluate_script "window.confirm = function () { return true; };"
end
def ok_dialog
  page.evaluate_script "window.alert = function () { return true; };"
end
def cancel_dialog
  page.evaluate_script "window.confirm = function () { return false; };"
end