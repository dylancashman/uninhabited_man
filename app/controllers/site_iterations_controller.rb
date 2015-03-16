class SiteIterationsController < ApplicationController
  before_action :set_site_iteration, only: [:show, :edit, :update, :destroy]
  before_filter :check_admin, only: [:new, :edit, :create, :update, :destroy]

  # GET /site_iterations
  # GET /site_iterations.json
  def index
    @site_iterations = SiteIteration.order('iteration_number DESC').all
  end

  # GET /site_iterations/1
  # GET /site_iterations/1.json
  def show
  end

  # GET /site_iterations/new
  def new
    @tags = Tag.all
    @site_iteration = SiteIteration.new
  end

  # GET /site_iterations/1/edit
  def edit
  end

  # POST /site_iterations
  # POST /site_iterations.json
  def create
    @site_iteration = SiteIteration.new(site_iteration_params)

    respond_to do |format|
      if @site_iteration.save
        format.html { redirect_to @site_iteration, notice: 'Site Iteration was successfully created.' }
        format.json { render :show, status: :created, location: @site_iteration }
      else
        format.html { render :new }
        format.json { render json: @site_iteration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site_iterations/1
  # PATCH/PUT /site_iterations/1.json
  def update
    respond_to do |format|
      if @site_iteration.update(site_iteration_params)
        format.html { redirect_to @site_iteration, notice: 'Site Iteration was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_iteration }
      else
        format.html { render :edit }
        format.json { render json: @site_iteration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site_iterations/1
  # DELETE /site_iterations/1.json
  def destroy
    @site_iteration.destroy
    respond_to do |format|
      format.html { redirect_to site_iterations_url, notice: 'Site Iteration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_iteration
      @site_iteration = SiteIteration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_iteration_params
      params.require(:site_iteration).permit(:iteration_title, :iteration_description, :referential_post_id, :screenshot)
    end
end
