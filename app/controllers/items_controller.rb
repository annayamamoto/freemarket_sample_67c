class ItemsController < ApplicationController

  before_action :set_item, except: [:index, :new, :create, :get_category_children, :get_category_grandchildren]
  before_action :set_ategory_parent_array, only: [:new, :create, :edit, :update]

  def index
    @items = Item.all.includes(:images).order("created_at DESC")
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
    @item = Item.new(item_params)
    
    if @item.save
      redirect_to root_path
      flash.now[:alert] = "商品を出品しました。"
    else
      flash.now[:alert] = "空欄を入力してください。"
      render :new
      
    end
  end

  def edit
    redirect_to 出品ページ if current_user.id != @item.saler_id
  end

  def show
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

def destory
  if @item.saler_id == current_user.id && @item.destory
    redirect_to root_path
  end
end

  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  private

  def item_params
    
    params.require(:item).permit(:name, :price, :status, :delivery_charge, :address, :date, :detail, :brand, :buyer_id, images_attributes: (:url )).merge(saler_id: current_user.id, category_id: params[:category_id])
    
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_ategory_parent_array
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end
end

