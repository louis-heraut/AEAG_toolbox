# Copyright 2021-2023 Louis Héraut (louis.heraut@inrae.fr)*1,
#                     Éric Sauquet (eric.sauquet@inrae.fr)*1
#
# *1   INRAE, France
#
# This file is part of AEAG_toolbox R toolbox.
#
# AEAG_toolbox R toolbox is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# AEAG_toolbox R toolbox is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with AEAG_toolbox R toolbox.
# If not, see <https://www.gnu.org/licenses/>.


# Script that manages the call to the right process in order to
# realise plottings of data analyses.


## 0. SHAPEFILE LOADING ______________________________________________
# Shapefile importation in order to do it only once time
if (!exists("Shapefiles")) {
    print("### Loading shapefiles")
    Code = levels(factor(data$Code))
    Shapefiles = load_shapefile(
        computer_data_path, Code,
        france_dir, france_file,
        bassinHydro_dir, bassinHydro_file,
        regionHydro_dir, regionHydro_file,
        entiteHydro_dir, entiteHydro_file,
        entiteHydro_coord,
        river_dir, river_file,
        river_selection=river_selection,
        river_length=river_length,
        toleranceRel=toleranceRel)
}

logo_path = load_logo(resources_path, logo_dir, logo_to_show)
# icon_path = file.path(resources_path, icon_dir)


## 1. HYDROMETRIC STATIONS LAYOUT ____________________________________
### 1.1. Flow time series for stations _______________________________
if ('serie_plot' %in% to_do) {
    # Square root computation
    df_sqrt = compute_sqrt(data)
    # Layout
    layout_panel(to_plot=c('datasheet'),
                 df_meta=df_meta,
                 data=list(data,
                              df_sqrt),
                 var=list('Q', 'sqrt(Q)'),
                 event=list('chronique', 'chronique'),
                 unit=list('m^{3}.s^{-1}', 'm^{3/2}.s^{-1/2}'),
                 axis_xlim=axis_xlim,
                 info_header=data,
                 shapefile_list=shapefile_list,
                 figdir=figdir,
                 logo_path=logo_path,
                 pdf_chunk=pdf_chunk)
}

### 1.2. Analyses layout _____________________________________________
if ('trend_plot' %in% to_do) {    
    layout_panel(to_plot=to_plot_station,
                 df_meta=df_meta,
                 data=data_analyse,
                 df_trend=df_trend_analyse,
                 var=var_analyse,
                 event=event_analyse,
                 unit=unit_analyse,
                 samplePeriod=samplePeriod_analyse,
                 glose=glose_analyse,
                 structure=structure,
                 period_trend=period_trend,
                 period_change=period_change,
                 colorForce=TRUE,
                 exXprob=exXprob,
                 info_header=data,
                 time_header=data,
                 foot_note=TRUE,
                 info_height=2.8,
                 time_height=3,
                 var_ratio=3,
                 foot_height=1.25,
                 shapefile_list=shapefile_list,
                 figdir=figdir,
                 filename_opt='',
                 resdir=resdir,
                 logo_path=logo_path,
                 zone_to_show=zone_to_show,
                 pdf_chunk=pdf_chunk,
                 show_colorEvent=show_colorEvent)
}


## 2. BREAK LAYOUT ___________________________________________________
if ('break_plot' %in% to_do) {
    # For all the variable
    for (v in var) {
        # Gets the break results for the variable
        df_break = DF_BREAK[[v]]
        
        histogram(df_break, df_meta, title=v, figdir=figdir)    
        cumulative(df_break, df_meta, title=v, dyear=8, figdir=figdir)
    }
}


## 3. CLIMATE LAYOUT _________________________________________________
if ('climate_trend_plot' %in% to_do) {
    sheet_stationnarity_short(
        meta, data,
        dataEX, metaEX, trendEX,
        period_trend_show=period_trend,
        linetype_per=c('dashed', 'solid'),
        exProb=exProb,
        logo_path=logo_path,
        Shapefiles=Shapefiles,
        paper_size=c(21, 18),
        figdir=today_figdir,
        df_page=NULL,
        verbose=subverbose)
}
