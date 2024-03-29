class HomeController < ApplicationController
  def index
    set_menu('inicio')
    @noticia = Article.where(category: 'noticia').
                      where("published_at < ?", Time.now).
                      order('published_at ASC').last
    @idea = Idea.where("published_at < ?", Time.now).
                 order('published_at ASC').last
  end

  # Noticias list
  def noticias
    set_menu('noticias')
    if params[:tag].present?
      @noticias = Article.where(category: 'noticia').
                          where("published_at < ?", Time.now).
                          tagged_with(params[:tag]).
                          order('published_at DESC').
                          page(params[:page]).per(10)
    else
      @noticias = Article.where(category: 'noticia').
                          where("published_at < ?", Time.now).
                          order('published_at DESC').
                          page(params[:page]).per(10)
    end
    @noticias_destacadas = Article.where(category: 'noticia').
                                   where("published_at < ?", Time.now).
                                   where(pin: true).
                                   order('published_at DESC').limit(5)
    @noticias_archivo = Article.where(category: 'noticia').
                                where("published_at < ?", Time.now).
                                order('published_at DESC').limit(3)
  end

  # Noticia
  def noticia
    set_menu('noticias')
    @noticia = Article.where(category: 'noticia').
                       where("published_at < ?", Time.now).
                       includes(comments: :user).
                       friendly.
                       find(params[:id])
  end

  # Inciativas list
  def iniciativas_sociales
    set_menu('iniciativas')
    if params[:tag].present?
      @iniciativas = Article.where(category: 'iniciativa').
                             where("published_at < ?", Time.now).
                             tagged_with(params[:tag]).
                             order('published_at DESC').
                             page(params[:page]).per(10)
    else
      @iniciativas = Article.where(category: 'iniciativa').
                             where("published_at < ?", Time.now).
                             order('published_at DESC').
                             page(params[:page]).per(10)
    end

    @iniciativas_destacadas = Article.where(category: 'iniciativa').
                                      where("published_at < ?", Time.now).
                                      where(pin: true).order('published_at DESC').limit(5)
    @iniciativas_archivo = Article.where(category: 'iniciativa').
                                   where("published_at < ?", Time.now).
                                   order('published_at DESC').limit(3)
  end

  # Iniciativa
  def iniciativa
    set_menu('iniciativas')
    @iniciativa = Article.where(category: 'iniciativa').
                          where("published_at < ?", Time.now).
                          includes(comments: :user).
                          friendly.
                          find(params[:id])
  end



  # Ideas list
  def ideas
    set_menu('ideas')
    category = params[:category]
    if category.present?
      set_submenu(category)
      @ideas = Idea.where(category: category).
                    where("published_at < ?", Time.now).
                    order('published_at DESC').
                    includes(:user).
                    page(params[:page]).per(6)
    else
      @ideas = Idea.where("published_at < ?", Time.now).
                    order('published_at DESC').
                    includes(:user).
                    page(params[:page]).per(6)
    end

    #Ideas search
    if params[:search]
      @ideas = Idea.search(params[:search]).
                    where("published_at < ?", Time.now).
                    order('published_at DESC').
                    includes(:user).
                    page(params[:page]).per(6)
    else
      @ideas = Idea.where(category: category).
                    where("published_at < ?", Time.now).
                    order('published_at DESC').
                    includes(:user).
                    page(params[:page]).per(6)
    end
  end

  def ideas_tag
    set_menu('ideas')
    tag = params[:tag]
    @ideas = Idea.where("published_at < ?", Time.now).
                  tagged_with(tag).
                  order('published_at DESC').
                  includes(:user).
                  page(params[:page]).per(6)
    render :ideas
  end

  # Idea
  def idea
    set_menu('ideas')
    @idea = Idea.where("published_at < ?", Time.now).
                 includes(comments: :user).
                 friendly.
                 find(params[:id])
    set_submenu(@idea.category.pluralize)
  end

  # Organizations list
  def organizations
    #@organizations = Organization.order('name').
     #                             page(params[:page]).per(10)
    set_menu('compartir')
    set_submenu('organizaciones')

    #Buscador por CP de Organizaciones
    if params[:search]
      @organizations = Organization.search(params[:search]).
                                    order('name').
                                    page(params[:page]).per(10)
    else
      @organizations = Organization.order('name').
                                    page(params[:page]).per(10)
    end
  end #organizations list close

  # Organization
  def organization
    @organization = Organization.friendly.
                                 find(params[:id])
    set_menu('compartir')
    set_submenu('organizaciones')
  end

  # Ad list
  def particulares
    set_menu('compartir')
    set_submenu('particulares')

    #Poner los alimentos disponibles
    #@alimentos = Ad.give.available.includes(:user).page(params[:page])
    #Poner alimentos disponibles y reservados
    #@alimentos = Ad.give.includes(:user).
    #                      where(status: [1,2]).
    #                      page(params[:page]).per(10)
    if params[:search] || params[:zipcode]
      @alimentos = Ad.give.includes(:user).
                           search(params[:search], params[:zipcode], params[:food_category]).
                           where(status: [1,2]).
                           where("pick_up_date IS NULL OR pick_up_date >= ?", Date.today).
                           page(params[:page]).per(12)
    else
      @alimentos = Ad.give.includes(:user).
                           where(status: [1,2]).
                           where("pick_up_date IS NULL OR pick_up_date >= ?", Date.today).
                           page(params[:page]).per(12)
    end

  end
end
