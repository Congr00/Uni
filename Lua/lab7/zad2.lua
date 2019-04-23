if verbose >= 10 then verbose_level = 'large'
elseif verbose >= 5 then verbose_level = 'medium'
else verbose_level = 'low'
end
developer_debug_on = verbose_level == 'large'
window_height = 500
window_ratio = 0.75