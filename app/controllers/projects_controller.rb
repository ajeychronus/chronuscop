class ProjectsController < ApplicationController
  before_filter :authenticate_user!


  def index
  end

  def create
    @project = current_user.projects.build(params[:project])
    if( @project.save) then
      redirect_to projects_path, :flash => {:success => "Successfully added project"}
    else
      render 'new'
    end
  end

  def new
    @project = Project.new      # necessary to use form_for
  end

  def edit
  end

  def show
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @project.translations } # required to use a xml-parser-client.
    end
  end

  def update
  end

  def destroy
  end

end
