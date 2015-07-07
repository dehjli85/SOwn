class StudentPerformanceVerificationsController < ApplicationController
  before_action :set_student_performance_verification, only: [:show, :edit, :update, :destroy]

  # GET /student_performance_verifications
  # GET /student_performance_verifications.json
  def index
    @student_performance_verifications = StudentPerformanceVerification.all
  end

  # GET /student_performance_verifications/1
  # GET /student_performance_verifications/1.json
  def show
  end

  # GET /student_performance_verifications/new
  def new
    @student_performance_verification = StudentPerformanceVerification.new
  end

  # GET /student_performance_verifications/1/edit
  def edit
  end

  # POST /student_performance_verifications
  # POST /student_performance_verifications.json
  def create
    @student_performance_verification = StudentPerformanceVerification.new(student_performance_verification_params)

    respond_to do |format|
      if @student_performance_verification.save
        format.html { redirect_to @student_performance_verification, notice: 'Student performance verification was successfully created.' }
        format.json { render :show, status: :created, location: @student_performance_verification }
      else
        format.html { render :new }
        format.json { render json: @student_performance_verification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_performance_verifications/1
  # PATCH/PUT /student_performance_verifications/1.json
  def update
    respond_to do |format|
      if @student_performance_verification.update(student_performance_verification_params)
        format.html { redirect_to @student_performance_verification, notice: 'Student performance verification was successfully updated.' }
        format.json { render :show, status: :ok, location: @student_performance_verification }
      else
        format.html { render :edit }
        format.json { render json: @student_performance_verification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_performance_verifications/1
  # DELETE /student_performance_verifications/1.json
  def destroy
    @student_performance_verification.destroy
    respond_to do |format|
      format.html { redirect_to student_performance_verifications_url, notice: 'Student performance verification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_performance_verification
      @student_performance_verification = StudentPerformanceVerification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_performance_verification_params
      params.require(:student_performance_verification).permit(:classroom_activity_pairing_id, :student_user_id)
    end
end
