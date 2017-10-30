 use Cwd;
  use File::Spec;
  use Text::Corpus::CNN;
  use Data::Dump qw(dump);
  use Log::Log4perl qw(:easy);
  Log::Log4perl->easy_init ($INFO);
  my $corpusDirectory = File::Spec->catfile (getcwd(), 'corpus_cnn');
  my $corpus = Text::Corpus::CNN->new (corpusDirectory => $corpusDirectory);
  my $totalDocuments = $corpus->getTotalDocuments;
  my %allCategories;
  for (my $i = 0; $i < $totalDocuments; $i++)
  {
    eval
      {
        my $document = $corpus->getDocument(index => $i);
        next unless defined $document;
        my $categories = $document->getCategories();
        foreach my $category (@$categories)
        {
          my $categoryNormalized = lc $category;
          $allCategories{$categoryNormalized} = [0, $category] unless exists $allCategories{$categoryNormalized};
          $allCategories{$categoryNormalized}->[0]++;
        }
      };
  }
  my @allCategories = sort {$b->[0] <=> $a->[0]} values %allCategories;
  my $topCategories = 10;
  $topCategories = @allCategories if (@allCategories < $topCategories);
  for (my $i = 0; $i < $topCategories; $i++)
  {
    print join (' ', @{$allCategories[$i]}) . "\n";
  }