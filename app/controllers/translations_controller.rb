class TranslationsController < ApplicationController
  before_filter :authenticate_user!


  def index
    @project = Project.find(params[:project_id])

    # Handling the case when only translations updated after last sync are needed.
    # last_update_at is an optional parameter.
    last_update_at = params[:last_update_at]

    # if the last_update_at parameter is passed then use it.
    if (last_update_at) then
      last_update_at = last_update_at.to_i
      time_obj = Time.at(last_update_at)
      @translations = @project.translations.where("updated_at > ?",time_obj)
    else
      @translations = @project.translations
    end


    respond_to do |format|
      format.html
      format.xml { render :xml => @translations }
    end
  end

  def manage                    # Action to manage translations.
    @project = Project.find(params[:project_id])

    if(!params[:language])
      flash[:error] = "No language parameter passed."
      redirect_to project_path(@project)
    else
      @default_translations = @project.translations.where("language = ?",0)
      @language_hash = Hash.new
      @project.translations.where("language = ?",params[:language]).each do |t|
        @language_hash[t.key] = t.value
      end
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

  def add                       # Action to add or update default translations.
    if(params[:translations_xml_string] == nil) then
      puts "Translations parameter missing."
    else
      require 'xmlsimple'
      translations_hash = XmlSimple.xml_in(params[:translations_xml_string])
      @project = Project.find(params[:project_id])

      translations_hash.each do |key,value|

        # Handling the default translations.
        t = Translation.find_by_key(key)
        if ( t ) then
          t.value = value
          t.save
        else

          @translation = @project.translations.build()
          @translation.key = key
          @translation.value = value
          @translation.language = 0 # 0 is the code for default.
          if ! @translation.save then
            puts "record could not be saved."
          end
        end

        # Handling the english translations that will be added.
        en_key = key.sub(/default/,"en")
        t2 = Translation.find_by_key(en_key)

        # If there is no such key then add it. If there is one
        # then don't touch it.
        if( ! t2 ) then
          @en_translation = @project.translations.build()
          @en_translation.key = en_key
          @en_translation.value = value
          @en_translation.language = 1 # 1 is the language code for english

          if ! @en_translation.save then
            puts "record could not be saved."
          end
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
