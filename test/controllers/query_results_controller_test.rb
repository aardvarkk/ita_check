require 'test_helper'

class QueryResultsControllerTest < ActionController::TestCase
  setup do
    @query_result = query_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:query_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create query_result" do
    assert_difference('QueryResult.count') do
      post :create, query_result: { itinerary: @query_result.itinerary, price: @query_result.price }
    end

    assert_redirected_to query_result_path(assigns(:query_result))
  end

  test "should show query_result" do
    get :show, id: @query_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @query_result
    assert_response :success
  end

  test "should update query_result" do
    patch :update, id: @query_result, query_result: { itinerary: @query_result.itinerary, price: @query_result.price }
    assert_redirected_to query_result_path(assigns(:query_result))
  end

  test "should destroy query_result" do
    assert_difference('QueryResult.count', -1) do
      delete :destroy, id: @query_result
    end

    assert_redirected_to query_results_path
  end
end
