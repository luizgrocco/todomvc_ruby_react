class Api::V1::TasksController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_logged_user

  def index
    # sleep 5

    render json: @logged_user.tasks
  end

  def destroy
    task = @logged_user.tasks.find(params[:id])

    task.destroy
  end

  def create
    # task = Task.create!(create_params.merge(completed: false))
    # render json: task, status: :created # 201 - Created

    task = @logged_user.tasks.build(create_params.merge(completed: false))
    # task = Task.new(create_params.merge(completed: false, user: @logged_user))
    # task = Task.new(create_params.merge(completed: false, user_id: @logged_user.id))

    if task.save
      render json: task, status: :created # 201 - Created
    else
      render json: task.errors, status: :unprocessable_entity # 401
    end
  end

  def update
    task = @logged_user.tasks.find(params[:id])

    if task.update(update_params)
      render json: task, status: :ok
    else
      render json task.errors, status: :unprocessable_entity # 401
    end
  end

  private 
  def create_params
    params.permit(:title)
  end

  def update_params
    params.permit(:completed)
  end

  def set_logged_user
    @logged_user = User.last # Let's pretend the last user in the DB is the one logged in
  end
end
