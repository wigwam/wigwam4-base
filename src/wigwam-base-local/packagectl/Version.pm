#!/usr/bin/perl

package Packagectl::Version;

use Carp;

require Exporter;

@Packagectl::Version::ISA = qw (Exporter);
@Packagectl::Version::EXPORT_OK = 
  qw (compare does_intersect to_interval intersect is_empty is_point union);

my $version_regex = qr%^\s*(\S+?)(\-(\d+))?\s*$%;

sub compare ($$)
{
  my ($a, $b) = @_;

  my $upstream_a;
  my $upstream_b;
  my $release_a;
  my $release_b;

  $a =~ m#^$version_regex$# or croak "bad version $a";
  $upstream_a = $1;
  $release_a = $3 || 0;

  $b =~ m#^$version_regex$# or croak "bad version $b";
  $upstream_b = $1;
  $release_b = $3 || 0;

  if ($upstream_a ne $upstream_b)
    {
      my @dots_a;
      my @dots_b;
      my $first = 1;

      @dots_a = split /\./, $upstream_a;
      @dots_b = split /\./, $upstream_b;

      while (@dots_a > 0 && @dots_b > 0)
        {
          my $cur_a;
          my $cur_b;

          $cur_a = shift @dots_a;
          $cur_b = shift @dots_b;

          if (   $cur_a eq int ($cur_a)
              && $cur_b eq int ($cur_b))
            {
              return $cur_a <=> $cur_b unless $cur_a == $cur_b;
            }
          else
            {
              return $cur_a cmp $cur_b unless $cur_a eq $cur_b;
            }

          $first = 0;
        }

      if (@dots_a > 0)
        {
          return 1;
        }
      elsif (@dots_b > 0)
        {
          return -1;
        }
    }

  return $release_a <=> $release_b;
}

sub to_interval ($)
{
  my ($version_spec) = @_;

  $version_spec ||= "any";

  my @specs = split /;/, $version_spec;

  my @intervals;

  while (@specs > 0)
    {
      my $spec = pop @specs;

      if ($spec =~ m#\[\s*(\S+)\s*,\s*(\S+)\]#)
        {
          push @intervals, [ $1, $2 ];
        }
      elsif ($spec =~ m#\[\s*(\S+)\s*,\s*(\S+)\)#)
        {
          push @intervals, [ $1, "$2 MINUS EPSILON" ];
        }
      elsif ($spec =~ m#\(\s*(\S+)\s*,\s*(\S+)\]#)
        {
          push @intervals, [ "$1 PLUS EPSILON", $2 ];
        }
      elsif ($spec =~ m#\(\s*(\S+)\s*,\s*(\S+)\)#)
        {
          push @intervals, [ "$1 PLUS EPSILON", "$2 MINUS EPSILON" ];
        }
      elsif ($spec =~ m#\(\s*(\S+)\s*,\s*(\)|\])#)
        {
          push @intervals, [ "$1 PLUS EPSILON", "INFINITY" ];
        }
      elsif ($spec =~ m#\[\s*(\S+)\s*,\s*(\)|\])#)
        {
          push @intervals, [ $1, "INFINITY" ];
        }
      elsif ($spec =~ m#(\[|\()\s*,\s*(\S+)\)#)
        {
          push @intervals, [ "MINUS INFINITY", "$1 MINUS EPSILON" ];
        }
      elsif ($spec =~ m#(\[|\()\s*,\s*(\S+)\]#)
        {
          push @intervals, [ "MINUS INFINITY", $1 ];
        }
      elsif ($spec =~ m#any# || $spec =~ m#latest#)
        {
          # any is essentially latest now, given how the planner works

          push @intervals, [ "MINUS INFINITY", "INFINITY" ];
        }
      elsif ($spec =~ m#^\s*(\S+?\-\d+)\s*$#)
        {
          # bare version number, with release number

          push @intervals, [ $1, $1 ];
        }
      elsif ($spec =~ m#^\s*(\S+?)\s*$#)
        {
          # this is a bare version number, w/o release number
          # so we'll take any release number
          # really need a way to say "infinite release number"
          # but we'll use 2112 for now :)

          push @intervals, [ "$1-0", "$1-2112" ];
        }
      else
        {
          croak "illegal spec '$spec'";
        }
    }

  return \@intervals;
}

sub er_compare ($$)
  {
    my ($er_a, $er_b) = @_;

    if ($er_a eq $er_b)
      {
        return 0;
      }
    elsif ($er_a eq "MINUS INFINITY")
      {
        return -1;
      }
    elsif ($er_a eq "INFINITY")
      {
        return 1;
      }
    elsif ($er_b eq "MINUS INFINITY")
      {
        return 1;
      }
    elsif ($er_b eq "INFINITY")
      {
        return -1;
      }
    elsif ($er_a =~ m%(.+) PLUS EPSILON%)
      {
        my $exact_a = $1;

        if ($er_b =~ m%(.+) PLUS EPSILON%)
          {
            return compare ($exact_a, $1);
          }
        elsif ($er_b =~ m%(.+) MINUS EPSILON%)
          {
            my $exact_b = $1;

            return compare ($exact_a, $exact_b) || 1;
          }
        else # er_b is straight version number
          {
            return compare ($exact_a, $er_b) || 1;
          }
      }
    elsif ($er_a =~ m%(.+) MINUS EPSILON%)
      {
        my $exact_a = $1;

        if ($er_b =~ m%(.+) PLUS EPSILON%)
          {
            my $exact_b = $1;

            return compare ($exact_a, $exact_b) || -1;
          }
        elsif ($er_b =~ m%(.+) MINUS EPSILON%)
          {
            return compare ($exact_a, $1);
          }
        else # er_b is straight version number
          {
            return compare ($exact_a, $er_b) || -1;
          }
      }
    else # er_a is straight version number
      {
        if ($er_b =~ m%(.+) PLUS EPSILON%)
          {
            my $exact_b = $1;

            return compare ($er_a, $exact_b) || -1;
          }
        elsif ($er_b =~ m%(.+) MINUS EPSILON%)
          {
            my $exact_b = $1;

            return compare ($er_a, $exact_b) || 1;
          }
        else # er_b is straight version number
          {
            return compare ($er_a, $er_b);
          }
      }
  }

sub is_inside ($$)
  {
    my ($point, $int) = @_;

    return    er_compare ($int->[0], $point) <= 0
           && er_compare ($point, $int->[1]) <= 0;
  }

sub intersect_one ($$)
  {
    my ($interval_a, $interval_b) = @_;

    if (is_inside ($interval_a->[0], $interval_b))
      {
        if (is_inside ($interval_a->[1], $interval_b))
          {
            return $interval_a;
          }
        else
          {
            return [ $interval_a->[0], $interval_b->[1] ];
          }
      }
    elsif (is_inside ($interval_a->[1], $interval_b))
      {
        return [ $interval_b->[0], $interval_a->[1] ];
      }
    elsif (   is_inside ($interval_b->[0], $interval_a)
           && is_inside ($interval_b->[1], $interval_a))
      {
        return $interval_b;
      }
    else
      {
        return undef;
      }
  }

sub intersect ($$)
  {
    my ($int_a, $int_b) = @_;

    my @intersection;

    foreach my $interval (@$int_a)
      {
        push @intersection, 
          grep { defined } 
            map { intersect_one ($interval, $_) }
              @$int_b;
      }

    return \@intersection;
  }

sub does_intersect ($$)
{
  my $i = intersect ($_[0], $_[1]);

  return scalar @$i;
}

sub is_point ($)
{
  my ($interval) = @_;

  return    scalar @$interval == 1
         && $interval->[0]->[0] eq $interval->[0]->[1];
}

sub is_empty ($)
{
  my ($interval) = @_;

  return scalar @$interval == 0;
}

sub union ($$)
  {
    my ($interval_a, $interval_b) = @_;

    my @result = @{$interval_a};
    push @result, @{$interval_b};

    return \@result;
  }


1;
