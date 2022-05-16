class TasksController < ApplicationController
  before_action :validate_user, only: [:new,:index,:show, :create, :edit, :update, :destroy]
  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true)
    respond_to do |format| 
      format.html
      format.xlsx {render xlsx: 'download',filename: "tasks.xlsx"}
    end
       
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(name: params[:task][:name],
       description: params[:task][:description],
        priority: params[:task][:priority],
        status: params[:task][:status])

    if @task.save
      redirect_to tasks_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path
    else
      render :edit, status: :unprocessable_entity
    end

  end

  def validate_user
    unless user_signed_in?
      redirect_to root_path
    end
  end
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path, status: :see_other
  end
  
  private
  def task_params
    params.require(:task).permit(:name, :description, :priority, :status)
  end
end
