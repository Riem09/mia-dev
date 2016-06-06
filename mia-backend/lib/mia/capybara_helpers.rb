module Mia
  module CapybaraHelpers
    #
    # def offset(selector)
    #   result = page.evaluate_script <<-JavaScript
    #     function () {
    #       return $("#{selector}").offset()
    #     }()
    #   JavaScript
    #   result
    # end
    #

    def accept_dialog
      page.evaluate_script "window.confirm = function () { return true; };"
    end
    def ok_dialog
      page.evaluate_script "window.alert = function () { return true; };"
    end
    def cancel_dialog
      page.evaluate_script "window.confirm = function () { return false; };"
    end
  end
end