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

  def addlanguage               # Action to add a language.
    @project = Project.find(params[:id])

    # Checking for the presence and validity of the parameter :language
    if(! params[:language]) then
      flash[:error] = "No parameter :language"
      redirect_to projects_path(@project)
    end

    # Adding language.
    if(! @project.languages) then
      @project.languages = params[:language].to_s
      @project.save
      flash[:success] = "Added language."
      redirect_to project_path(@project)
      return
    else
      arr = @project.languages.split(/:/)

      if(arr.include?(params[:language].to_s)) then
        flash[:notice] = "Language is already added."
        redirect_to project_path(@project)
        return
      else
        @project.languages = @project.languages + ":" + params[:language].to_s
        @project.save
        flash[:success] = "Successfully added language."
        redirect_to project_path(@project)
        return
      end
    end

  end

  def update
  end

  def destroy
  end

end
