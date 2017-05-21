class BarcodeItemsController < ApplicationController
  def index
    @barcode_items = current_organization.barcode_items.includes(:item).filter(filter_params)
    @items = current_organization.items.barcoded_items
  end

  def create
    @barcode_item = current_organization.barcode_items.create(barcode_item_params)
    redirect_to @barcode_item, notice: "New barcode added!"
  end

  def new
    @barcode_item = current_organization.barcode_items.new
    @items = current_organization.items.all
  end

  def edit
    @barcode_item = current_organization.barcode_items.includes(:item).find(params[:id])
    @items = current_organization.items.all
  end

  def show
    @barcode_item = current_organization.barcode_items.includes(:item).find(params[:id])
  end

  def update
    @barcode_item = current_organization.barcode_items.find(params[:id])
    @barcode_item.update_attributes(barcode_item_params)
    redirect_to @barcode_item, notice: "Barcode updated!"
  end

  def destroy
    current_organization.barcode_items.find(params[:id]).destroy
    redirect_to barcode_items_path
  end

  def find
    @barcode_value = BarcodeItem.find_by(value: params[:value])
    render json: @barcode_value.to_json(only: [:value, :item_id, :quantity])
  end

private
  def barcode_item_params
    params.require(:barcode_item).permit(:value, :item_id, :quantity)
  end

  def filter_params
    return {} unless params.has_key?(:filters)
    params.require(:filters).slice(:item_id, :less_than_quantity, :greater_than_quantity, :equal_to_quantity)
  end
end
