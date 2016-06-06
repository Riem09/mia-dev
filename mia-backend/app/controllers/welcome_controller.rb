class WelcomeController < ApplicationController

  def search
    render 'search'
  end

  def frontend
    render 'frontend', :layout => 'ember'
  end

  def style_guide
  end

  def no_op
    render :text => 'Noop'
  end

  def upload_test
    render 'upload_test', :layout => nil
  end

end
