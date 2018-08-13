class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
	def unique_words(mat)
		words = []

		mat.each do |row|
			row.each do |item|
				words.append(item)
			end
		end

		words = words.uniq

		counts = {}

		words.each do |word|
			counts[word] = 0
		end

		mat.each do |row|
			row.each do |item|
				counts[item] += 1
			end
		end	

		new_mat = []

		mat.each do |row|

			temp_row = []

			row.each do |item|
				if counts[item] == 1 then
					#copy to new mat
					temp_row.append(item)
				end
			end

			new_mat.append(temp_row)
		end

		return new_mat
	end

	 def data_clean(s)
		#remove UTF
		#remove stopwords c
		#remove urls c
		#remove non-alpha c
		#remove rt c

		s = s.downcase

		splits = s.split(' ')
		
		buffer = ""
		i = 0

		stopwords = []

		File.open("/users/john/desktop/fil-stopwords.txt", "r") do |f|
			f.each_line do |el|
				stopwords.append(el)
			end  		
		end

		splits.each do |sp|	
			found = false

			stopwords.each do |sw|
				
				if sp.chomp == sw.chomp then
					found = true
				end
			end

			if found == false then
				if i == 0 then
					buffer += sp
					i = 1
				else
					buffer += " " + sp
				end
			end
		end

		s = buffer
		
		s = s.gsub(/(?:f|ht)tps?:\/[^\s]+/, '') #remove url
		
		s = s.gsub(/[^0-9a-z ]/i, '') #removes non-alpha
		
		return s
	end


end
