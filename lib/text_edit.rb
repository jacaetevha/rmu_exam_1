module TextEditor
  class Document
    def initialize
      @contents = ""
      @snapshots = []
      @reverted  = []
    end
    
    attr_reader :contents

    def add_text(text, position=-1)
      snapshot(Commands::InsertText text: text, position: position)
    end

    def remove_text(first=0, last=contents.length)
      snapshot(Commands::RemoveText start: first, finish: last)
    end

    def undo
      return if @snapshots.empty?
      snapshot = @snapshots.pop
      snapshot.undo(self.contents)
      @reverted << snapshot
      self
    end

    def redo
      return if @reverted.empty?
      snapshot = @reverted.pop
      snapshot.call(self.contents)
      @snapshots << snapshot
      self
    end

    private
      def snapshot s
        s.call(self.contents)
        @snapshots << s
        @reverted = []
      end
  end
end

module Commands
  def self.InsertText(options={})
    InsertText.new(options[:text], options[:position])
  end

  def self.RemoveText(options={})
    RemoveText.new(options[:start], options[:finish])
  end

  class InsertText

    def initialize text, position
      @text, @position = text, position
    end

    def call contents
      contents.insert(@position, @text)
      self
    end

    def undo contents
      from = @position < 0 ? contents.length - @text.length : @position
      RemoveText.new(from, from + @text.length).call(contents)      
      self
    end
  end

  class RemoveText
    def initialize start_position, end_position
      @start_position, @end_position = start_position, end_position
    end

    def call contents
      @removed_text = contents.slice!(@start_position...@end_position)
      self
    end

    def undo text
      return self unless executed?
      InsertText.new(@removed_text, @start_position).call(text)
      self
    end

    private
      def executed?
        false == @removed_text.nil?
      end
  end
end
