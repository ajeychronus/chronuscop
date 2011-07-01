class TranslationsController < ApplicationController
  before_filter :authenticate_user!


  def index
    @project = Project.find(params[:project_id])

    respond_to do |format|
      format.html
      format.xml { render :xml => @project.translations }
    end
  end

  def create
    @project = Project.find(params[:project_id])
    @translation = @project.translations.build(params[:translation])

    if(@translation.save)
      redirect_to project_translations_path,:flash => { :success => "Translation saved."}
    else
      redirect_to project_translations_path, :flash => { :error => "Could not save"}
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @translation = @project.translations.build()
  end

  def add                       # action to add all translations.
    if(params[:translations_xml_string] == nil) then
      puts "Translations parameter missing."
    else
      require 'xmlsimple'
      translations_hash = XmlSimple.xml_in(params[:translations_xml_string])

      translations_hash.each do |key,value|
        t = Translation.find_by_key(key)
        if ( t ) then
          t.value = value
          t.save
        else
          @project = Project.find(params[:project_id])
          @translation = @project.translations.build()
          @translation.key = key
          @translation.value = value
          @translation.save
        end
      end

    end
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

end
