class Merchant::DiscountsController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
  end

  def create
    merchant = current_user.merchant
    discount = merchant.discounts.new(discount_params)
    if discount.save
      redirect_to "/merchant/discounts"
    else
      generate_flash(discount)
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(params[:id])
    if params[:active]
      discount.update!(active: params[:active])
      redirect_to "/merchant/discounts"
    else
      update_discount(discount)
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:percentage, :item_count, :updated_at)
  end

  def update_discount(discount)
    if discount.update(discount_params)
      redirect_to "/merchant/discounts/#{discount.id}"
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{discount.id}/edit"
    end
  end

end
