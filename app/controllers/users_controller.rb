class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update,]
  before_action :authenticate!
  before_action :correct_user, only: [:edit, :update,:show]
  before_action :admin_user,only: [:create,:index,:new]
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page],per_page: 8)#.order(created_at: :desc)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: '创建用户成功' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      if @user.is_admin?
         @user.update(user_params)
      else
         @user.update(user_params_password)
      end

    respond_to do |format|
      if @user.update(user_params) || @user.update(user_params_password)
        format.html { redirect_to @user, notice: '修改用户信息成功' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def correct_user#如果不是本人或者管理员，则跳转到根页面
      set_user
      @current_user = User.find_by(id: session[:user_id])
      redirect_to(root_path) unless  @current_user == @user || @current_user.is_admin? #current_user?(@user)
      end
    end

    def admin_user#如果不是管理员，则跳转到根页面
      @current_user = User.find_by(id: session[:user_id])
      redirect_to(root_path) unless @current_user.is_admin?
    end



    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

    def user_params_password
      params.require(:user).permit(:password, :password_confirmation)

    end
