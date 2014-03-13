class QueryResultsController < ApplicationController
  before_action :set_query_result, only: [:show, :edit, :update, :destroy]

  # GET /query_results
  # GET /query_results.json
  def index
    @query_results = QueryResult.all
  end

  # GET /query_results/1
  # GET /query_results/1.json
  def show
  end

  # GET /query_results/new
  def new
    @query_result = QueryResult.new
  end

  # GET /query_results/1/edit
  def edit
  end

  # POST /query_results
  # POST /query_results.json
  def create
    @query_result = QueryResult.new(query_result_params)

    respond_to do |format|
      if @query_result.save
        format.html { redirect_to @query_result, notice: 'Query result was successfully created.' }
        format.json { render action: 'show', status: :created, location: @query_result }
      else
        format.html { render action: 'new' }
        format.json { render json: @query_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /query_results/1
  # PATCH/PUT /query_results/1.json
  def update
    respond_to do |format|
      if @query_result.update(query_result_params)
        format.html { redirect_to @query_result, notice: 'Query result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @query_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /query_results/1
  # DELETE /query_results/1.json
  def destroy
    @query_result.destroy
    respond_to do |format|
      format.html { redirect_to query_results_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_query_result
      @query_result = QueryResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def query_result_params
      params.require(:query_result).permit(:itinerary, :price)
    end
end
