
function [handles,eval_time]=GTM_PlotBasics(MESH,PROBLEM,LOAD,RESP,PlotID,MDATA,handles)

% Jan Havelka (jnhavelka@gmail.com)
% Copyright 2016, Czech Technical University in Prague
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

tic

if ~PROBLEM.General.PresentMode
    mode='normal';
else
    mode='presentation';
end
video_pause=0.1;

%% Plot the response field
if PlotID == 1
    pot_field=BasePlot( MESH,RESP,[1,2,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\Delta p\,\mathrm{[Pa]}$','Pressure difference field'},mode );
    pause(video_pause);
    
    % iterate over current patterns
    for c_idx=2:size(RESP,2)
        % update the current field
        UpdatePlot( pot_field,RESP(:,c_idx) );
        pause(video_pause);
    end
end


%% Draw response field + gradients
if PlotID == 3
    % draw the potential field
    pot_field=BasePlot( MESH,LOAD.M_cfull,[1,3,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\Delta p\quad\mathrm{[Pa]}$','$\mathrm{Potential\,difference\,field}$'},mode );
    
    % distribute basis derivatives along diagonal of an matrix for
    % gradient calculation without cycle over elements
    r=reshape(repmat(1:2*MESH.nelements,3,1),6,[]);
    c=repmat(reshape(1:3*MESH.nelements,3,[]),2,1);
    GM=sparse(r,c,MESH.B);
    
    % calculate gradients of potential field (to include material -
    % multiply diagonal block elements of GM with corresponding values/tensors)
    q_pot=-GM*LOAD.M_cfull(MESH.Elements(:,1:3)',:);
    % plot the gradient and electrodes
    grad_field=BasePlot( MESH,reshape(q_pot(:,1),2,[])',[1,3,2],'Currents',mode );
    % save the matrix for generating gradients
    setappdata(grad_field,'GM',GM);
    
    % VIDEO RECORD
    if PROBLEM.Video.Record
        pot = VideoWriter('pot.avi','Motion JPEG AVI');
        pot.Quality=PROBLEM.Video.Quality;
        pot.FrameRate=PROBLEM.Video.FrameRate;
        open(pot);
        
        grad = VideoWriter('grad.avi','Motion JPEG AVI');
        grad.Quality=PROBLEM.Video.Quality;
        grad.FrameRate=PROBLEM.Video.FrameRate;
        open(grad);
    end
    % VIDEO RECORD
    
    % iterate over all time steps
    for c_idx=1:size(RESP,2)
        % update the current field
        % VIDEO RECORD
        if PROBLEM.Video.Record
            UpdatePlot( pot_field,LOAD.M_cfull(:,c_idx) );
            % use external anti aliasing
            %             pot_smooth=myaa;
            writeVideo(pot,getframe(pot_smooth));
            %             close gcf;
            
            UpdatePlot( grad_field,reshape(q_pot(:,c_idx),2,[])' );
            % use external anti aliasing
            %             grad_smooth=myaa;
            writeVideo(grad,getframe(grad_smooth));
            %             close gcf;
        else
            UpdatePlot( pot_field,RESP(:,c_idx) );
            UpdatePlot( grad_field,reshape(q_pot(:,c_idx),2,[])' );
        end
        % VIDEO RECORD
        pause(video_pause);
    end
    
    % VIDEO RECORD
    if PROBLEM.Video.Record
        setappdata(grad_field,'video_file',grad);
        setappdata(pot_field,'video_file',pot);
    end
    % VIDEO RECORD
    handles={pot_field,grad_field};
end



























%% Draw response field + material + material difference
if PlotID == 4
    if isempty(handles)
        % draw the potential field
        pot_field=BasePlot( MESH,LOAD.M_cfull,[1,3,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$T\,\mathrm{[^oC]}$','$\mathrm{Potential\,field}$'},mode );
        % draw the real potential field (the one that one tries to match)
        pot_field_true = trimesh(MDATA.MESH.Elements(:,1:3),MDATA.MESH.Nodes(:,1),MDATA.MESH.Nodes(:,2),LOAD.M_ofull(:,1));
        set(pot_field_true,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(pot_field,'back_surf');
        min_zval=min([LOAD.M_cfull(:);LOAD.M_ofull(:)]);
        max_zval=max([LOAD.M_cfull(:);LOAD.M_ofull(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(pot_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval+eps]);
        
        % get coordinates of measurements and plot them
        X=MESH.Nodes(LOAD.m_nodes,1)';
        Y=MESH.Nodes(LOAD.m_nodes,2)';
        Z=LOAD.M_cfull(LOAD.m_nodes,1)';
        measurement_scheme=scatter3(X,Y,Z,'r','LineWidth',3);
        % plot the real measured values
        Z=LOAD.M_ofull(MDATA.LOAD.m_nodes,1)';
        measurement_scheme_true=scatter3(X,Y,Z,'b','LineWidth',3);
        
        % error of sigma field
        sigma_err_field=BasePlot( MESH,MESH.ETN*(RESP.sigma_comp{end}./RESP.sigma_comp{end}),[2,3,2],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\lambda_i/\lambda_t$','$\mathrm{Conductivity\,fit}$'},mode );
        set(gca,'ZLim',[0,1.5]);
        
        % plot solution field (material in each iteration)
        sigma_field=BasePlot( MESH,MESH.ETN*RESP.sigma_comp{end},[2,3,3],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\lambda\,\mathrm{[\frac{W}{m \cdot K}]}$','$\mathrm{Conductivity\,field}$'},mode );
        
        sigma_true_field = trimesh(MDATA.MESH.Elements(:,1:3),MDATA.MESH.Nodes(:,1),MDATA.MESH.Nodes(:,2),MDATA.MESH.ETN*MDATA.MATERIAL.sigma);
        set(sigma_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(sigma_field,'back_surf');
        min_zval=min([MDATA.MATERIAL.sigma(:);RESP.sigma_comp{end}(:)]);
        max_zval=max([MDATA.MATERIAL.sigma(:);RESP.sigma_comp{end}(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(sigma_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        
        
        
        
        
        
        
        % plot the gradient and electrodes
        %         capacity_err_field=BasePlot( MESH,MESH.ETN*(RESP.cv_comp{end}./(RESP.c.*RESP.rho)),[2,3,5],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$c_i/c_t$','$\mathrm{Capacity\,fit}$'},mode );
        capacity_err_field=BasePlot( MESH,MESH.ETN*(RESP.cv_comp{end}./RESP.cv_comp{end}),[2,3,5],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$c_i/c_t$','$\mathrm{Capacity\,fit}$'},mode );
        set(gca,'ZLim',[0,1.5]);
        
        % plot solution field (material in each iteration)
        capacity_field=BasePlot( MESH,MESH.ETN*RESP.cv_comp{end},[2,3,6],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$c_v\,\mathrm{[\frac{W \cdot s}{m^3 \cdot K}]}$','$\mathrm{Capacity\,field}$'},mode );
        
        capacity_true_field = trimesh(MDATA.MESH.Elements(:,1:3),MDATA.MESH.Nodes(:,1),MDATA.MESH.Nodes(:,2),MDATA.MESH.ETN*(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho));
        set(capacity_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(capacity_field,'back_surf');
        min_zval=min([reshape(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho,[],1);RESP.cv_comp{end}(:)]);
        max_zval=max([reshape(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho,[],1);RESP.cv_comp{end}(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(capacity_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        
        % VIDEO RECORD
        if PROBLEM.Video.Record
            pot = VideoWriter('pot.avi','Uncompressed AVI');
            %             pot = VideoWriter('pot.avi','Motion JPEG AVI');
            %             pot.Quality=PROBLEM.Video.Quality;
            pot.FrameRate=PROBLEM.Video.FrameRate;
            open(pot);
            
            cap_mat = VideoWriter('cap_map.avi','Uncompressed AVI');
            %             cap_mat = VideoWriter('cap_map.avi','Motion JPEG AVI');
            %             cap_mat.Quality=PROBLEM.Video.Quality;
            cap_mat.FrameRate=PROBLEM.Video.FrameRate;
            open(cap_mat);
            
            sigma_mat = VideoWriter('sigma_mat.avi','Uncompressed AVI');
            %             sigma_mat = VideoWriter('sigma_mat.avi','Motion JPEG AVI');
            %             sigma_mat.Quality=PROBLEM.Video.Quality;
            sigma_mat.FrameRate=PROBLEM.Video.FrameRate;
            open(sigma_mat);
        end
        % VIDEO RECORD
        
        % iterate over current patterns
        UpdatePlot( sigma_field,MESH.ETN*RESP.sigma_comp{end} );
        UpdatePlot( sigma_err_field,MESH.ETN*(RESP.sigma_comp{end}./RESP.sigma_comp{end}) );
        %         UpdatePlot( sigma_field,MESH.ETN*RESP.sigma_comp{end} );
        %         UpdatePlot( sigma_err_field,MESH.ETN*(RESP.sigma_comp{end}./RESP.sigma) );
        
        UpdatePlot( capacity_field,MESH.ETN*RESP.cv_comp{end} );
        UpdatePlot( capacity_err_field,MESH.ETN*(RESP.cv_comp{end}./RESP.cv_comp{end}) );
        for c_idx=1:size(LOAD.M_cfull,2)
            % update the current potential field
            UpdatePlot( pot_field,LOAD.M_cfull(:,c_idx) );
            % update the original potential field
            UpdatePlot( pot_field_true,LOAD.M_ofull(:,c_idx) );
            % update the model measurement scatter plot
            UpdatePlot( measurement_scheme,LOAD.M_cfull(LOAD.m_nodes,c_idx));
            % update the real measurement scatter plot
            UpdatePlot( measurement_scheme_true,LOAD.M_ofull(MDATA.LOAD.m_nodes,c_idx));
            % VIDEO RECORD
            if PROBLEM.Video.Record
                writeVideo(pot,getframe(getappdata(pot_field,'main_figure')));
                writeVideo(cap_mat,getframe(getappdata(capacity_field,'main_figure')));
                writeVideo(sigma_mat,getframe(getappdata(sigma_field,'main_figure')));
            end
            % VIDEO RECORD
            pause(video_pause);
        end
        % VIDEO RECORD
        if PROBLEM.Video.Record
            setappdata(sigma_field,'video_file',sigma_mat);
            setappdata(capacity_field,'video_file',cap_mat);
            setappdata(pot_field,'video_file',pot);
        end
        % VIDEO RECORD
        handles={pot_field,measurement_scheme,sigma_err_field,sigma_field,pot_field_true,measurement_scheme_true,capacity_field,capacity_err_field};
    else % if you have the handles - just update the fields
        UpdatePlot( handles{3},MESH.ETN*(RESP.sigma_comp{end}./RESP.sigma_comp{end}) );
        UpdatePlot( handles{4},MESH.ETN*RESP.sigma_comp{end} );
        %         UpdatePlot( handles{3},MESH.ETN*(RESP.sigma_comp{end}./RESP.sigma) );
        %         UpdatePlot( handles{4},MESH.ETN*RESP.sigma_comp{end} );
        
        UpdatePlot( handles{8},MESH.ETN*(RESP.cv_comp{end}./RESP.cv_comp{end}) );
        UpdatePlot( handles{7},MESH.ETN*RESP.cv_comp{end} );
        %         UpdatePlot( handles{8},MESH.ETN*(RESP.cv_comp{end}./(RESP.c.*RESP.rho)) );
        %         UpdatePlot( handles{7},MESH.ETN*RESP.cv_comp{end} );
        for c_idx=1:size(LOAD.M_cfull,2)
            % update the current field
            UpdatePlot( handles{1},LOAD.M_cfull(:,c_idx) );
            % update the original potential field
            UpdatePlot( handles{5},LOAD.M_ofull(:,c_idx) );
            % update the model measurement scatter plot
            UpdatePlot( handles{2},LOAD.M_cfull(LOAD.m_nodes,c_idx));
            % update the real measurement scatter plot
            UpdatePlot( handles{6},LOAD.M_ofull(MDATA.LOAD.m_nodes,c_idx));
            pause(video_pause);
            % VIDEO RECORD
            if PROBLEM.Video.Record
                writeVideo(getappdata(handles{1},'video_file'),getframe(getappdata(handles{1},'main_figure')));
                writeVideo(getappdata(handles{4},'video_file'),getframe(getappdata(handles{4},'main_figure')));
                writeVideo(getappdata(handles{7},'video_file'),getframe(getappdata(handles{7},'main_figure')));
            end
            % VIDEO RECORD
        end
    end
end
















%% Draw material fields
if PlotID == 5
    if isempty(handles)
        % draw the potential field
        
        % plot solution field (material in each iteration)
        sigma_field=BasePlot( MESH,MESH.ETN*RESP.sigma_comp{end},[1,3,3],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\lambda\,\mathrm{[W/(m \cdot K)]}$','$\mathrm{Conductivity\,field}$'},mode );
        
        sigma_true_field = trimesh(MDATA.MESH.Elements(:,1:3),MDATA.MESH.Nodes(:,1),MDATA.MESH.Nodes(:,2),MDATA.MESH.ETN*MDATA.MATERIAL.sigma);
        set(sigma_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(sigma_field,'back_surf');
        min_zval=min([MDATA.MATERIAL.sigma(:);RESP.sigma_comp{end}(:)]);
        max_zval=max([MDATA.MATERIAL.sigma(:);RESP.sigma_comp{end}(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(sigma_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        % update the contour plots etc
        UpdatePlot( sigma_field,MESH.ETN*RESP.sigma_comp{end} );
        
        % plot solution field (material in each iteration)
        capacity_field=BasePlot( MESH,MESH.ETN*RESP.cv_comp{end},[1,3,3],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$c_v\,\mathrm{[W \cdot s/(m^3 \cdot K)]}$','$\mathrm{Capacity\,field}$'},mode );
        
        capacity_true_field = trimesh(MDATA.MESH.Elements(:,1:3),MDATA.MESH.Nodes(:,1),MDATA.MESH.Nodes(:,2),MDATA.MESH.ETN*(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho));
        set(capacity_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(capacity_field,'back_surf');
        min_zval=min([reshape(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho,[],1);RESP.cv_comp{end}(:)]);
        max_zval=max([reshape(MDATA.MATERIAL.c.*MDATA.MATERIAL.rho,[],1);RESP.cv_comp{end}(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(capacity_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        % update the contour plots etc
        UpdatePlot( capacity_field,MESH.ETN*RESP.cv_comp{end} );
        
        pause(video_pause);
        
        
        handles={sigma_field,capacity_field};
    else % if you have the handles - just update the fields
        UpdatePlot( handles{1},MESH.ETN*RESP.sigma_comp{end} );
        UpdatePlot( handles{2},MESH.ETN*RESP.cv_comp{end} );
        pause(video_pause);
    end
end

















% plot the electrodes and measurements
if PlotID == -2
    figure;
    back_mesh = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_mesh,'EdgeColor','black','FaceColor',[0.9 0.9 0.9]);
    hold all
    plot([MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]',...
        [MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]','k','LineWidth',1.5);
    
    if strncmpi(mode,'normal',4)
        
        % plot the measurement nodes
        % any - for ALL inject patterns
        scatter(MESH.Nodes(any(LOAD.m_nodes,2),1),MESH.Nodes(any(LOAD.m_nodes,2),2),10,'MarkerEdgeColor',[.7 .1 .1],...
            'MarkerFaceColor',[0.7 .1 .1],...
            'LineWidth',1.5)
        % plot the identifiers
        text(MESH.Nodes(any(LOAD.m_nodes,2),1),MESH.Nodes(any(LOAD.m_nodes,2),2),num2str((1:sum(any(LOAD.m_nodes,2)))'),'Color','red','HorizontalAlignment','center','VerticalAlignment','bottom');
        title('Measurement nodes scheme');
    else
        scatter(MESH.Nodes(any(LOAD.m_nodes,2),1),MESH.Nodes(any(LOAD.m_nodes,2),2),100,'MarkerEdgeColor',[.7 .1 .1],...
            'MarkerFaceColor',[0.7 .1 .1],...
            'LineWidth',1.5)
        
    end
    
    if strncmpi(mode,'present',4)
        % ---------------------------------------
        set(gca,'color','w');
        set(gcf,'color','w');
        % ---------------------------------------
    end
    
    
    axis equal
    axis off
    view(0,90);
    % save figure to outputs
    savefig(gcf,[fullfile(cd,'output',MESH.MeshName),'_electrodes']);
end












% get the evaluation time
eval_time=toc;






